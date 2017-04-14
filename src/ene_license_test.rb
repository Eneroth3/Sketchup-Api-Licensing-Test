# Eneroth Licensing API Test

# Copyright Julia Christina Eneroth, eneroth3@gmail.com

require "sketchup.rb"
require "extensions.rb"

module EneLicensingAPITest

  AUTHOR      = "Julia Christina Eneroth"
  CONTACT     = "#{AUTHOR} at eneroth3@gmail.com"
  COPYRIGHT   = "#{AUTHOR} #{Time.now.year}"
  DESCRIPTION =
    "Experiment to figure out how the licensing API works."
  ID          =  File.basename __FILE__, ".rb"
  NAME        = "Eneroth Licensing Api Test"
  VERSION     = "1.0.0"

  PLUGIN_ROOT = File.expand_path(File.dirname(__FILE__))

  PLUGIN_DIR = File.join(PLUGIN_ROOT, ID)

  ex = SketchupExtension.new(NAME, File.join(PLUGIN_DIR, "main"))
  ex.description = DESCRIPTION
  ex.version     = VERSION
  ex.copyright   = COPYRIGHT
  ex.creator     = AUTHOR
  Sketchup.register_extension(ex, true)

end
