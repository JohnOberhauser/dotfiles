To import the theme, go to plugins and install plugin from disk.

Select the theme jar file `./Varda-Intellij-Theme/Varda-Intellij-Theme.jar`

To build the theme, ensure these plugins are installed:
- plugin dev kit
- python
- jetpack compose

Then open `./Varda-Intellij-Theme` as its own project.  File -> build -> prepare for distribution
If the option isn't there, make sure ./.idea/modules.xml is pointing to the iml file in the root directory, and
not the one in the .idea folder

When editing the schema, only edit Varda.  Then apply the changes to the other themes using schemaCopier.py