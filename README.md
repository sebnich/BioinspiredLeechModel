# Bioinspired leech model

This model was created for the QUBES lab to represent the nervous system of a leech. The purpose is to study distributed sensing, multimodal sensory integration, and the mapping of neural behavior to physical behaviors. 

An elliptical model from Jensen 2010 was adapted to simulate the distributed mechanical and visual sensors along a leeches body. Data from Lehmkuhl 2018 was used to determine neural behavior from individual S cells from the leech which was then computed into a physical behavior. The goal of this model is to replicate laboratory data found in Dr. Harley's 2011 study where leeches were subjected to combinations of mechanical and visual stimuli frequencies and the navigational sucess was measured accordingly. 

The main function is Experiment_MVu.m which will test mechanical, visual, and multimodal stimuli and output average find rate figures for each. Experiment_2.m allows the user to test each stimuli on its own and will output three figures: average steps, average path length multiple, and average find rate. 

Navigational_env_v3 can be used to visualize the trajectory of an agent with specifically inputted mehcanical and visual frequencies. A color for the agent must also be inputted. 

