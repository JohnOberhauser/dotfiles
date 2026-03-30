export default {
  multipass: true, // boolean
  plugins: [
    'preset-default', // built-in plugins enabled by default
    'removeXMLNS',
    'removeDimensions',
    'removeOffCanvasPaths', // enable built-in plugins by name
  ],
};
