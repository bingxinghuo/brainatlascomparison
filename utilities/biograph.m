function h = biograph(cm,ids,varargin)
%BIOGRAPH creates a bioinformatics graph object
%
%   BIOGRAPH will be removed in a future release. Use GRAPH or DIGRAPH
%   instead.
%
%   BG = BIOGRAPH(CM) creates a graph object using the connection matrix
%   CM. All non-diagonal and positive entries in CM indicate connected
%   nodes; rows represent the source nodes and columns the sink nodes. Node
%   IDs default to the row/column numbers. 
%
%   BG = BIOGRAPH(CM,IDs) sets the node IDs. IDs is a string vector or cell
%   array of character vectors with the same number of elements as the number
%   of row/columns in CM (nodes). IDs may also be a character array with the
%   same number of rows as nodes or a string with the same number of
%   characters as nodes. IDs must be unique.
%
%   A graph can exist without having geometrical information, only node
%   connections are needed. However to render a graph into a HG figure, the
%   positions of the nodes and the curves for the edges must be calculated
%   using the DOLAYOUT method. This method calculates the missing object
%   properties that will lead to a clean and uncluttered 2-D rendering.
%
%   A BIOGRAPH object has public and private properties. Examples of
%   private properties are the edge control points that describe the
%   splines or lines used to connect nodes. 
%
%   Access public properties in a BIOGRAPH object with the GET and SET
%   commands or as fields in structures using 'dot' notation.
%
%   When a BIOGRAPH is already rendered into a HG figure, you are allowed
%   to change the public properties. Properties in the figure will be
%   automatically updated except for those that interact with the DOLAYOUT
%   method, in such case you need to call the DOLAYOUT method manually or
%   use the right-button context menu to refresh the layout. 
%
%   PUBLIC PROPERTIES OF THE BIOGRAPH OBJECT:
%
%   1) LAYOUT PROPERTIES:
%
%   ID:              User defined character string.
%   Label:           User defined character string.
%   Description:     User defined character string.
%   LayoutType:      Select the type of algorithm for the layout engine.
%                    Options are 'hierarchical' (default), 'radial' and
%                    'equilibrium'.
%   LayoutScale:     A positive number to scale the size of the nodes before
%                    calling the layout engine.
%   Scale:           A positive number to post-scale the node coordinates.
%   NodeAutoSize:    'on' (default) or 'off' to turn on/off the
%                    pre-calculation of the node size before calling the
%                    layout engine. 
%   ShowTextInNodes: Selects which node property is shown in the layout.
%                    Options are 'label' (default), 'id' and 'none'.
%   EdgeType:        Type of edges, it can be 'curved' (default),
%                    'segmented' or 'straight'. Curved or segmented edges
%                    occur only when necessary to avoid obstruction by
%                    nodes. 'Equilibrium' and 'Radial' layout types cannot
%                    produce curved or segmented edges. 
%   EdgeTextColor:   RGB three element numeric vector, defaults to [0 0 0].
%   ShowArrows:      'on' (default) or 'off' to show/hide arrows of the
%                    edges.
%   ArrowSize:       Sets the size of the arrows, defaults to 8 (pts).
%   ShowWeights:     'on' or 'off' (default) to show/hide text indicating
%                    the weight of the edges.
%   EdgeFontSize:    Positive number, defaults to 8 (pts).
%   NodeCallback:    Name of function or function handle for the user
%                    callback for all nodes (defaults to 
%                    @(node) inspect(node)). 
%   EdgeCallback:    Name of function or function handle for the user
%                    callback for all edges (defaults to
%                    @(edge) inspect(edge)). 
%   CustomNodeDrawFcn: Function handle to customized function to draw
%                    nodes, defaults to [].
%   Nodes:           Vector with handles to nodes (read only).
%   Edges:           Vector with handles to edges (read only).
%
%   2) NODE PROPERTIES:
%
%   ID:          Character string defined when the BIOGRAPH object is
%                created. Node IDs must be unique.
%   Label:       User defined character string, defaults to an empty string
%                when the node is created. 
%   Description: User defined character string, defaults to an empty string
%                when the node is created.
%   Position:    Defaults to [], automatically computed by the layout
%                engine.
%   Shape:       Defaults to 'box', other options are 'ellipse', 'circle',
%                'rect', 'rectangle', 'diamond', 'trapezium', 'house',
%                'invtrapezium', 'invhouse', and, 'parallelogram'.
%   Size:        Defaults to [10 10], automatically computed before calling
%                the layout engine using the current font size and shape of
%                the node.
%   Color:       RGB three element numeric vector, defaults to [1 1 0.7].
%   LineWidth:   Positive number, defaults to 1.
%   LineColor:   RGB three element numeric vector, defaults to [0.3 0.3 1].
%   FontSize:    Positive number, defaults to 8 points.
%   TextColor:   RGB three element numeric vector, defaults to [0 0 0].
%   UserData:    User data container, defaults to [].
%
%   3) EDGE PROPERTIES:
%
%   ID:          Character string. Edge IDs are automatically generated from
%                the node IDs. Edge IDs may be modified as long as the IDs
%                are unique. 
%   Label:       User defined character string, defaults to an empty string.
%   Description: User defined string, defaults to an empty string.
%   Weight:      User defined value, defaults to 1, 
%   LineWidth:   Positive number, defaults to 0.5.
%   LineColor:   RGB three element numeric vector, defaults to 
%                [0.5 0.5 0.5]. 
%   UserData:    User data container, defaults to [].
%
%   Example:
%     
%       % Create a BIOGRAPH object.
%       cm = [0 1 1 0 0;1 0 0 1 1;1 0 0 0 0;0 0 0 0 1;1 0 1 0 0];
%       bg1 = biograph(cm)
%       get(bg1.nodes,'ID')
% 
%       % Create a BIOGRAPH object and assign the node IDs.
%       cm = [0 1 1 0 0;1 0 0 1 1;1 0 0 0 0;0 0 0 0 1;1 0 1 0 0];
%       ids = {'M30931','L07625','K03454','M27323','M15390'};
%       bg2 = biograph(cm,ids)
%       get(bg2.nodes,'ID')
%
%   See also BIOGRAPH.BIOGRAPH/DOLAYOUT,
%   BIOGRAPH.BIOGRAPH/GETEDGESBYNODEID, BIOGRAPH.BIOGRAPH/GETNODESBYID,
%   BIOGRAPH.BIOGRAPH/VIEW, BIOGRAPH.NODE/GETANCESTORS,
%   BIOGRAPH.NODE/GETDESCENDANTS, BIOGRAPH.NODE/GETRELATIVES, GET, SET.

% Copyright 2003-2021 The MathWorks, Inc.

if nargin > 1
    ids = convertStringsToChars(ids);
end

if nargin > 2
    [varargin{:}] = convertStringsToChars(varargin{:});
end

if nargin>1 
    setDefaultIDS = false;
else
    setDefaultIDS = true;
end

n = size(cm, 1);

if islogical(cm)
    cm = double(cm);
end

% check CM
if isempty(cm) && (~setDefaultIDS && ~isempty(ids))
    error(message('bioinfo:biograph:biograph:InvalidEmptyCM'))
end

if ~isnumeric(cm) || ~isreal(cm) || diff(size(cm))
    error(message('bioinfo:biograph:biograph:InvalidCM'))
end
if any(diag(cm))
    warning(message('bioinfo:biograph:biograph:SelfConnected'))    
    cm = cm - diag(diag(cm));
end

% check the validity of the provided IDs
if ~setDefaultIDS
    if isempty(ids) %IDS is only a space holder
        setDefaultIDS = true;
    elseif ischar(ids) && isvector(ids) && numel(ids)==n
        ids = cellstr(ids(:));
    elseif ischar(ids) && size(ids,1)==n
        ids = strtrim(cellstr(ids));
    elseif numel(ids)~=n || ~iscellstr(ids)
       warning(message('bioinfo:biograph:biograph:InvalidString'))
       setDefaultIDS = true;
    end
end

if ~setDefaultIDS
    % check there are not invalid chars (i.e. control characters)
    if any(cellfun(@(x) any(x<' ' | (x>=127 & x<=159)),ids))
        warning(message('bioinfo:biograph:biograph:InvalidCharsInIDS'))
        for k = 1:n
            ids{k}(ids{k}<' '|(ids{k}>=127&ids{k}<=159)) = ' ';
        end
    end
    % check there are not repeated IDs
    if numel(unique(ids))~=n
        warning(message('bioinfo:biograph:biograph:NotUniqueIDS'))
       setDefaultIDS = true;
    end
end

% create default IDS when appropriate
if setDefaultIDS
    ids = cell(1,n);
    for k = 1:n
        ids{k} = sprintf('Node %d',k);
    end 
end

nvarargin = numel(varargin);
if nvarargin
    if rem(nvarargin,2) == 1
        error(message('bioinfo:biograph:biograph:IncorrectNumberOfArguments'));
    end
end

% create the biograph object
h = biograph.biograph(cm,ids,varargin);



