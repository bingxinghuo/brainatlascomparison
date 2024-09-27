# brainatlascomparison
*For any questions, or if you encounter problems configuring the environment to run the app/tool, please feel free to email me: bingxing.huo@gmail.com. I'm always happy to discuss!* <br>

This repository (https://github.com/bingxinghuo/brainatlascomparison/) contains the Matlab tool for the paper <a href="https://doi.org/10.1101/2024.05.06.592808">"Establishing neuroanatomical correspondences across mouse and marmoset brain structures."</a> (Mezias *et al*. bioRxiv)
There are two versions of the tool:
1. A standalone Matlab App for users without Matlab license. (*Installing Matlab Runtime is necessary, though.*)
2. A command line tool within the Matlab interface for Matlab users to maximize accessibility of the code.
#
# 1. Matlab App for visualizing atlas hierarchy and homologous correspondences in marmoset and mouse brains
The tool provides a graphical interface to visualize the corresponding brain regions in mouse and marmoset, and their respective positions in the atlas hierarchy. 
## Set up step by step
1) Download the zip file of <a href="https://github.com/bingxinghuo/brainatlascomparison/blob/0eca320db0fd17f2494105bda3cba3ba02e2a1bd/marmoset_mouse_region_compare_app_v2024.zip">marmoset_mouse_region_compare_app_v2024.zip</a><br>
2) Download and install Matlab Runtime, which does not require a Matlab license, using the links below. It also contains instruction for alternative approaches when Matlab Runtime installation fails. <br>
<b>Note:</b> Please only install the exact Matlab Runtime version as given by the following links: <br>
<a href="https://ssd.mathworks.com/supportfiles/downloads/R2022a/Release/8/deployment_files/installer/complete/maci64/MATLAB_Runtime_R2022a_Update_8_maci64.dmg.zip">MATLAB Runtime R2022a (9.12) for Mac </a><br>
<a href="https://ssd.mathworks.com/supportfiles/downloads/R2022a/Release/8/deployment_files/installer/complete/win64/MATLAB_Runtime_R2022a_Update_8_win64.zip">MATLAB Runtime R2022a (9.12) for Windows </a><br>
<a href="https://ssd.mathworks.com/supportfiles/downloads/R2022a/Release/8/deployment_files/installer/complete/glnxa64/MATLAB_Runtime_R2022a_Update_8_glnxa64.zip">MATLAB Runtime R2022a (9.12) for Linux </a><br>
<b>Note:</b> During installation, it asks you to choose a directory. (example screenshot below in mac) <br>
<img src="Screenshot 1.png"><br>
Then it shows the installation folder. Please keep this information. (example screenshot below in mac) <br>
<img src="Screenshot 2.png"><br>

4) To launch the App, in Terminal/command line tool, go to the directory of unzipped marmoset_mouse_region_compare_app_v2024 folder, run <br>
*./run_marmoset_mouse_region_compare_app.sh /Applications/MATLAB/MATLAB_Runtime/v912* <br>
   <b>Note:</b> This will help you set the environment variables automatically. <br>
## Use the tool step by step
1) Once launched, you should see "Select region" under either "Mouse" or "Marmoset". You may open up the list, or type in region acronym according to the nomenclature in respective atlases (Allen Mouse Brain Atlas and Paxinos Marmoset Brain Atlas).
2) The "Status" indicator on upper right corner turns yellow when the App is running and green when the results are displayed.<br>
<b>Note:</b> Images of mouse and marmoset brains are not to scale. They are purely for demonstration purposes to visualize the location of brain regions. 
# 2. Matlab interface tool for visualizing atlas hierarchy and homologous correspondences in marmoset and mouse brains 
This tool works in the Matlab environment which requires you to have an active Matlab license. 
## Set up step by step
1) Pull this repository to your local Matlab path. <b>Necessary folders and file:</b>"data", "viewbrains", "viewhierarchy", "utilities", and "marmoset_mouse_region_compare.m"
2) In the local directory, run "marmoset_mouse_region_compare.m" in the Matlab command interface.
## Use the tool step by step
*There will be text prompts in the command line that requests text inputs. After each input, press enter/return.* <br>
1) The user will be asked to specify a species: mouse (1) or marmoset (2).
2) The user is asked to enter "a brain region (ID, acronym, or partial region name)." Here <b>"ID"</b> is the *exact* numeric identification number given in the atlas; <b>"acronym"</b> is the *exact* acronym used in the atlas.  <b>"Partial region name"</b> provides an ambiguous option, where one can enter the text that is only a part of the full name of the brain region. <br>
<b>Note:</b> The mouse brain atlas is Allen Mouse Brain Atlas. The hierarchy with region names are available at <a href = "http://brainarchitecture.org/mouse-connectivity-home#tab-id-2">Mouse Connectivity Home -- Brain Architecture Project.</a><br>
The marmoset brain atlas is Paxinos Marmoset Brain Atlas. The hierarchy with region names are available at <a href = "http://marmoset.brainarchitecture.org/#tab-id-2">The Marmoset Brain Architecture.</a><br>
3) When there are multiple brain regions associated with the input text, a list of brain regions will show up. The user will be asked to specify which region they are querying by entering the <b>index number as shown in the first column of the list</b>.
4) Pop-up windows will appear showing:
   - 3D view comparisons of the brain region and subregions in the two reference atlases
   - Coronal view comparisons of the brain region and subregions
   - Hierarchical structures of the region's parent regions and all children branches. 
