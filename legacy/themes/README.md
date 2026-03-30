Adding a new theme:

1. Create color palette in main README
2. Create a new theme directory in `./setup/themes/`
3. Add a GTK theme in `./gtk/generator` and generate it
4. Create a new theme within the `./intellij/Varda-Intellij-Theme` project and reinstall the plugin in idea and android studio
5. Add all the necessary files to `./setup/themes/{themeName}` (copy another theme and modify the files to match the new theme)
6. Update `./setup/scripts/setTheme.sh`
7. Update okpanel by adding a new theme to the config