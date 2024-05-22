<!-- Section 1: Logo and short code description-->  <!--  -->
<a name="readme-top"></a>
<br /> <!-- break -->
<div align="center">  <!-- A block of content centred for the logo and description -->
  <a href="https://www.nature.com/articles/s41593-024-01633-3">  <!-- CLickable logo; TODO: change to the article link -->
    <img src="images/CL_logo.png" alt="Logo" width="80" height="100">
  </a>

  <h2 align="center">Mondragon-Gonzalez et al., 2024,  Nature Neuroscience</h2>  <!-- Header tag -->
  <h3 align="center">Closedloop TriFilterNet</h3>  <!-- Header tag -->
  
  <p align="center">
    TriFilterNet utilizes a feature selection and supervised classification approach to process electrophysiological recordings, identifying pre-grooming events within ongoing behavior. The system employs a set of triangular filters to reduce the size of the feature set, yielding a matrix of decorrelated coefficients. Subsequently, a minimal-architecture artificial neural network is used to classify behavioral states and detect pre-grooming instances based on these coefficients.
    <br />
    <!-- TODO: change to the article link -->
    <a href="https://www.nature.com/articles/s41593-024-01633-3"><strong> Link to article »</strong></a>
    <br />
  </p>
</div>

## Table of Contents 

- [1 System Requirements](#1-system-requirements)
- [2 Installation Guide](#2-installation-guide)
- [3 Description of Code's Functionality](#3-description-of-codes-functionality)
- [4 Instructions of Use](#4-instructions-of-use)
- [5 Citation](#5-citation)
- [6 License](#6-license)

## 1 System Requirements
* <b> MATLAB version: </b> The code was developped using Matlab R2017b and also tested using Matlab R2019b.
* <b> Operating System: </b> The code was developped and tested under Windows 7 and 10.
* <b> MATLAB Toolboxes: Deep Learning Toolbox </b>
* <b> Third-party MATLAB Packages: </b> wrapped functions of RHD2000 MATLAB RHD file reader (
<a href="https://intantech.com/downloads.html?tabSelect=Software&yPos=0"> <strong> link </strong> </a> to documentation)
and Kamil Wojcicki (2024). HTK MFCC MATLAB, Mathworks exchange <a href="https://www.mathworks.com/matlabcentral/fileexchange/32849-htk-mfcc-matlab"> <strong> link </strong> </a>, MATLAB Central File Exchange. </br>

<div align="right">[ <a href="#readme-top">↑ Back to top ↑</a> ]</div>

## 2 Installation Guide
<ol>

  <li> <a href="https://docs.github.com/fr/repositories/creating-and-managing-repositories/cloning-a-repository"> <strong> Clone </strong> </a> the repository to your local machine:
    <pre><code>git clone https://github.com/LizbethMG/Mondragon_NatNeuro_CL.git</code></pre>
  </li>
  <li>Navigate to the cloned directory:
    <pre><code>cd Mondragon_NatNeuro_CL</code></pre>
  </li>
  <li> Download the data used for the <a href="https://osf.io/kdmjt/?view_only=7a3e37c708df4d0198d48aa1f59dbb76"> `dataset1/m1` </a> and add it to your project's folder data/m1. </li>
  <li> Add the project folder to your MATLAB path. You can do this in two ways:</li>

<h5>Using the MATLAB Command Window</h5>
    <ul>
        <li>Open MATLAB.</li>
        <li>In the Command Window, type the following command, replacing <code>yourpath</code> with the path to your project:
            <pre><code>addpath('yourpath');
savepath;</code></pre> </li>
    </ul>
<h5>Using the MATLAB Set Path Dialog</h5>
    <ul>
        <li>Open MATLAB.</li>
        <li>On the Home tab, in the Environment section, click Set Path.</li>
        <li>Click Add with Subfolders.</li>
        <li>Browse to the project folder and click OK.</li>
        <li>Click Save and then Close to save the changes.</li>
    </ul>
   <li> You haven't installed Matlab's Deep Learning Toolbox yet, go to Matlab's main menu >> Adds-On>> Get Adds-on>> Search for "Deep Learning Toolbox" >> Install </li>
</ol>
Typical install time:  10 min.
<div align="right">[ <a href="#readme-top">↑ Back to top ↑</a> ]</div>

## 3 Description of Code's Functionality

<br> &rarr;  Please refer to <b>Figure 4</b> of the [article](https://github.com/LizbethMG/Mondragon_NatNeuro_CL) as it provides a detailed schematic description of the code's workflow. The complete description can be found in the Methods section.
<br> &diams; For more detailed information, users can refer to the in-code comments within the script and its functions.
The core functionality of the main script:
### INPUT 
*  `m1_config.m`  configuration file of the experiment
*  [data/ m1/](https://osf.io/kdmjt/?view_only=7a3e37c708df4d0198d48aa1f59dbb76) data files
### Configuration and initialization
* `continous_classif__settings.mlx`  settings for data processing 
### Data processing
* `continuous_classif_fct.m `  data processing is completely done in this function, including: 
#### Acquisition and segmentation
* `slmg_nextFromRecordedData.m`  retrieves the next data segment from a continuous ephys recording file
*  `slmg_read_Intan_files.m`  read ephys files in a folder 
*  `slmg_read_Intan_file.m`  read ephys from a single file
#### Feature decomposition
*  `slmg_power.m` computes the power from a signal sample.
*  `slmg_mfcc.m` computes cepstral coefficients from a signal.
#### Supervised learning
*  `slmg_NNCompute.m`  classification using an artificial neural network (single electrode)
*  `slmg_ClassNNdecision.m` classification prediction according to single electrode classification results
### OUTPUT
* `TimestampsPredict` pre-grooming classification timestamps

<b> &diams; Expected run time for demo: </b> For a 10-minute experiment (sampled at 30 kHz, 14 channels) like the one on the demo (m1), on a general-purpose computer expect the following approximately runtimes:
<br> ~ 8 min -- CPU: Intel Core i7-6700hq @ 2.6 GHz, RAM: 16 GB, Operating System: Windows 10 64-bit, Matlab 2019b.
<div align="right">[ <a href="#readme-top">↑ Back to top ↑</a> ]</div>

## 4 Instructions for Use

#### Working with the demo data
- Ensure you added the project folder to your MATLAB path and set it as the current folder. In Matlab Command Window type `pwd` the result should be `'YOUR_PATH\NatureNeuroscience_2024_TriFilterNet'`
- Run the Live Script file `continous_classif__settings.mlx`. It will run the code for the demo data (Dataset1/m1) for 10 minutes and return the predictions made in that time window.
#### Working with Dataset 1
Dataset 1  features the electrophysiological recordings and the associated grooming markers used in the paper to asses the closed-loop algorithm. 
The data is available at the [Open Science Framework](https://osf.io/) **DOI: 10.17605/OSF.IO/KDMJT**

- [Download](https://osf.io/kdmjt/?view_only=7a3e37c708df4d0198d48aa1f59dbb76) dataset 1.
- Add the downloaded folder to your MATLAB path containing the code, inside `4_data` 
Each sub-folder in the data set 1 corresponds to a single experiment. Each experiment has its configuration file and raw data.
- In the Live Script file `continous_classif__settings.mlx` simply change the path to the experimental data and the corresponding configuration files.
    <br> Example:
    - continuous_classif_settings.mlx >> `subjects_lists = "m1"` to analyze data for experiment m1
    - continuous_classif_settings.mlx >> `subjects_lists = ["m1", "m2", "m3"]` to analyze data for experiment m1 to m3

<div align="right">[ <a href="#readme-top">↑ Back to top ↑</a> ]</div>

## 5 Citation
If you use this code or data we kindly ask you to cite our work. 

- <b> Data: </b>
> (APA style) Mondragón-González, S. L. (2024, March 26). 2024_Mondragon-Gonzalez_NatureNeuroscience. https://doi.org/10.17605/OSF.IO/KDMJT

- <b> Article: </b> Mondragon et al 2024: [DOI link](https://www.nature.com/articles/s41593-024-01633-3)
> @article{Mondragon2024,
        title = {Closed-loop recruitment of striatal interneurons prevents compulsive-like grooming behaviours},
        author = {Sirenia Lizbeth Mondragón-González and Christiane Schreiweis and Eric Burguière},
        journal = {Nature Neuroscience},
        year = {2024},
        url = { https://www.nature.com/articles/s41593-024-01633-3 }}


<div align="right">[ <a href="#readme-top">↑ Back to top ↑</a> ]</div>

## 6 License
<a href="https://www.gnu.org/licenses/gpl-3.0.txt">  <!-- CLickable logo; TODO: change to the article link -->
    <img src="images/gplv3-or-later-sm.png" alt="Logo" width="90" height="38">
  </a>
<NatureNeuroscience_2024_TriFilterNet>
    Copyright (C) <2024>  <Sirenia Lizbeth Mondragón-González and Eric Burguière>

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <https://www.gnu.org/licenses/>.
<div align="right">[ <a href="#readme-top">↑ Back to top ↑</a> ]</div>
