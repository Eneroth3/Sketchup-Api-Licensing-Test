# Eneroth Licensing API Test

# Copyright Julia Christina Eneroth, eneroth3@gmail.com

module EneLicensingAPITest

  # The licensing API is not called when the plugin is loaded.
  # That would increase SketchUp loading time (even if just slightly).
  # It would also make SketchUp show it's own built in notification which is an
  # accessibility disaster. The notification is only shown for a few seconds,
  # making it impossible to read and very frustrating for any user who is a
  # slow reader or easily get stressed knowing of how little time there is.

  # Check if the extension is licensed. If not, tell the user and allow them to
  # visit Extension Warehouse to get a license.
  #
  # Note that this method can be easily overridden by a hacker just by opening
  # the namespace and create a new method by the same name that always returns
  # true. This method is only for providing the user interface. Additional
  # checks needs to be done inside the core methods of the plugin.
  #
  # Returns Boolean.
  def self.licensed?
    ext_lic = Sketchup::Licensing.get_extension_license(EXTENSION.id)
    unless ext_lic.licensed?
      msg = "#{EXTENSION.name} isn't licensed. Do you want to open the Extension Warehouse to get a license?"
      return unless UI.messagebox(msg, MB_YESNO) == IDYES

      # HACK: USe an off screen HTMLDialog to open the Extension's page in the
      # Extension Warehouse. There doesn't seem to be any other way to do this
      # supported by the API.
      #
      # Preferably there should be an Extension#view_in_ew class method.
      #
      # This method uses yet another extension identifier that isn't the
      # Extension#name or Extension#id but the trailing part of the URL in
      # Extension Warehouse, which is based on the title the extension was
      # originally submitted with.
      ew_identifier = "eneroth-licensing-api-test"
      html = <<-HTML
        <a href="skp:launchEW@#{ew_identifier}">Show in Extension Warehouse (should open automatically)</a>
        <script type="text/javascript">document.getElementsByTagName('a')[0].click();</script>
      HTML
      dlg = UI::WebDialog.new(EXTENSION.name, true, nil, 0, 0, 100_000, 0, true)
      dlg.set_html(html)
      dlg.show

    end

    ext_lic.licensed?
  end

  # This is the core method of the plugin. Imagine it does something useful
  # that users are willing to pay for and hackers willing to hack.
  def self.hello_world

    # Perform an additional license check inside the body of core methods.
    # Ruby is a very dynamic language but one thing it can't do is modifying
    # a method body without overriding the whole method (I think?).
    #
    # Use a locally hard-coded extension id instead of relying on Extension#id,
    # a class variable or constant since these can all be overridden by hackers.
    #
    # Contrary to normal coding conventions the following lines of code SHOULD
    # be copied into core methods and not be extracted as a method of its own.
    ext_id = "15dfa30f-4957-4549-8cdb-e97b5727a13a"
    ext_lic = Sketchup::Licensing.get_extension_license(ext_id)
    return unless ext_lic.licensed?

    # The useful code here...
    UI.messagebox("Hello World!\n\n(The extension is licensed to run)")
  end

  unless file_loaded?(__FILE__)
    file_loaded(__FILE__)

    menu = UI.menu("Plugins")
    menu = menu.add_submenu(EXTENSION.name)
    menu.add_item("Hello World") { hello_world if licensed?}
  end

end
