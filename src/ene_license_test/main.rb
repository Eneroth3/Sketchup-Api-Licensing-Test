# Eneroth Licensing API Test

# Copyright Julia Christina Eneroth, eneroth3@gmail.com

module EneLicensingAPITest

  # The licensing API is not called when the plugin is loaded.
  # That would increase SketchUp loading time (even if just slightly).
  # It would also make SketchUp show it's own built in notification which is an
  # accesability disaster. The notification is only shown for a few seconds,
  # making it impossible to read and very frustrating for any user who is a
  # slow rreader or easily get stressed knowing of how little time there is.

  # Check if the extension is licensed. If not, tell the user and allow them to
  # visit Extension Warehouse to get a license.
  #
  # Note that this method can be easily overriden by a hacker just by opening
  # the namespace and create a new method by the same name that always returns
  # true. This method is only for providing the user interface. Additional
  # checks needs to be done inside the core methods of the plugin.
  #
  # Returns Boolean.
  def self.licensed?
    # Do not store the extension ID in a constant or class variable as these can
    # be modified. Do not rely on SketchupExtension#id since your reference to
    # the extension object may have been hijacked. Instead hard-code the ID
    # wherever it is required.
    ext_id = "4e215280-dd23-40c4-babb-b8a8dd29d5ee"
    ext_lic = Sketchup::Licensing.get_extension_license(ext_id)
    unless ext_lic.licensed?
      msg = "#{NAME} isn't licensed. Do you want to open the Extension Warehouse to get a license?"
      return unless UI.messagebox(msg, MB_YESNO) == IDYES

      # HACK: USe a HTMLDialog to oprn thr Extenion's page in the Extension
      # Warehouse. There doesn't seem to be an other way to do this.
      # This method uses yet another extension identifier that isn't the
      # Extension#name or Extension#id but the trailing part of the URL in
      # Extension Warehouse, which is based on the title the extension was
      # submitted with.
      ew_identifier = "advanced-camera-tools"# TODO: Replace with the correct sting for this individual extension.
      html = <<-HTML
        <a href="skp:launchEW@#{ew_identifier}">link</a>
        <script type="text/javascript">document.getElementsByTagName('a')[0].click();</script>
      HTML
      dlg = UI::WebDialog.new("TITLE", true, nil, 0, 0, 10000, 0, true)
      dlg.set_html(html)
      dlg.show

    end

    ext_lic.licensed?
  end

  # This is the core method of the plugin. Imagine it does something useful
  # that users are willing to pay for and hackers willing to hack.
  def self.hello_world
    # Perform the exact same license check again inside the method body.
    # Ruby is a very dynamic language but one thing it can't do is modifying
    # a method body without overriding the whole method (I think?).
    #
    # Use a locally hardcoded extension id instead of relying on Extension#id,
    # a class variable or constant since these can all be overriden by hackers.
    ext_id = "4e215280-dd23-40c4-babb-b8a8dd29d5ee"
    ext_lic = Sketchup::Licensing.get_extension_license(ext_id)
    return unless ext_lic.licensed?

    UI.messagebox("Hello World!\n\n(The extension is licensed to run)")
  end

  unless file_loaded?(__FILE__)
    file_loaded(__FILE__)

    menu = UI.menu("Plugins")
    menu = menu.add_submenu(NAME)
    menu.add_item("Hello World") { hello_world if licensed?}
  end

end
