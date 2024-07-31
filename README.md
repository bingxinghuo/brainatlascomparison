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
1) Download the folder of marmoset_mouse_region_compare_app_v2024 (also contained in the zip file)
2) Follow instructions in the <b>readme.txt</b> to install Matlab Runtime, which does not require a Matlab license. It also contains instruction for alternative approaches when Matlab Runtime installation fails. <br>
<b>Note:</b> The App was developed in Matlab_R2022a, so please install the same Matlab Runtime version: <br>
<a href="https://ssd.mathworks.com/supportfiles/downloads/R2022a/Release/8/deployment_files/installer/complete/maci64/MATLAB_Runtime_R2022a_Update_8_maci64.dmg.zip">MATLAB Runtime R2022a (9.12) for Mac </a><br>
<a href="https://ssd.mathworks.com/supportfiles/downloads/R2022a/Release/8/deployment_files/installer/complete/win64/MATLAB_Runtime_R2022a_Update_8_win64.zip">MATLAB Runtime R2022a (9.12) for Windows </a><br>
<a href="https://ssd.mathworks.com/supportfiles/downloads/R2022a/Release/8/deployment_files/installer/complete/glnxa64/MATLAB_Runtime_R2022a_Update_8_glnxa64.zip">MATLAB Runtime R2022a (9.12) for Linux </a><br>

3) Launch the App by running marmoset_mouse_region_compare_app.sh <br>
   <b>or</b><br>
   Launch the App by running marmoset_mouse_region_compare_app.app (in Mac or Linux)<br>
   <b>Note:</b> It is possible that the Matlab Runtime is installed at a different directory from the default/assumed location in the App, as instructed in the readme.txt. In this case, please specify the location manually by running the shell script. For example, on a Mac, in the folder directory, you may need to run: <br>
*./run_marmoset_mouse_region_compare_app.sh /Applications/MATLAB/MATLAB_Runtime/v912* <br>

## Use the tool step by step
1) Once launched, you should see "Select region" under either "Mouse" or "Marmoset". You may open up the list, or type in region acronym according to the nomenclature in respective atlases (Allen Mouse Brain Atlas and Paxinos Marmoset Brain Atlas).
2) The "Status" indicator on upper right corner turns yellow when the App is running and green when the results are displayed.<br>
<b>Note:</b> Images of mouse and marmoset brains are not to scale. They are purely for demonstration purposes to visualize the location of brain regions. 
# 2. Matlab interface tool for visualizing atlas hierarchy and homologous correspondences in marmoset and mouse brains 
This tool works in the Matlab environment which requires you to have an active Matlab license. 
## Set up step by step
1) Pull this repository to your local Matlab path. <b>Necessary folders:</b>"data", "viewbrains", "viewhierarchy", "utilities", and "marmoset_mouse_region_compare.m"
2) In the local directory, run "marmoset_mouse_region_compare.m" in the Matlab command interface.
## Use the tool step by step
The user will be asked to specify a species (i.e. mouse or marmoset) and a brain region (ID, acronym, or partial region name) according to the nomenclature in respective atlases (Allen Mouse Brain Atlas and Paxinos Marmoset Brain Atlas). The tool will provide, in pop-up windows,
1) 3D view comparisons of the brain region and subregions in the two reference atlases
2) Coronal view comparisons of the brain region and subregions
3) Hierarchical structures of the region's parent regions and all children branches. 
