class J::Entry < ActiveRecord::Base

  before_save :default_values

  #-------------------------------------------------------------------------------
  # Assorted constants

  ENTRY_TYPES = %i(note event)
  FLAGS = %i(inspiration explore)

  ENTYPO_SYMBOLS = {
    note: "&#128196;",
    event: "&#128197;",
    inspiration: "&#128165;",
    explore: "&#59146;",
    important: "&#9733;"
  }

  HTML_SYMBOLS = {
    note: "&bull;",
    event: "&empty;",
    inspiration: "!",
    explore: "&curren;",
    important: "&sect;"
  }

  TEXT_SYMBOLS = {
    note: "•",
    event: "O",
    inspiration: "!",
    explore: "∞",
    important: "*"
  }


  #-------------------------------------------------------------------------------
  # Entry types and associated methods

  
    
  def entry_type
    @entry_type ||= ENTRY_TYPES[int_type]
  end

  def entry_type= e
    self.update_attribute(:int_type, ENTRY_TYPES.index(e)) if ENTRY_TYPES.include?(e)
  end

  def event?
    entry_type == :event
  end

  def note?
    entry_type == :note
  end

  #-------------------------------------------------------------------------------
  # Flags and methods


  def flags
    @flags ||= FLAGS.select{ |f| (int_flags & value_for_flag(f)) != 0 }
  end

  def add_flag f
    if FLAGS.include?(f)
      update_attribute(:int_flags, int_flags | value_for_flag(f))
    end
  end

  # Convert the entry to a string
  def to_s
    flags.map{ |f| TEXT_SYMBOLS[f] }.join("") +
    TEXT_SYMBOLS(self.entry_type) + 
    "] " +
    body
  end

  # Convert the entry to html.
  # Uses html symbols to represent flags and entries, and parses
  # the body through markdown before displaying. If you pass
  # :entypo=true, it will use entypo glyphs for flags.
  def to_html(entypo: false)
    html_flags(entypo:entypo) + " " + html_type(entypo:entypo) + " " + Markdown.new(body).to_html
  end

  # Display flags as html. If entypo is set to true,
  # will use entypo glyphs.
  def html_flags(entypo: false)
    if entypo
      flags.map { |f| ENTYPO_SYMBOLS[f] }.join("")
    else
      flags.map{ |f| HTML_SYMBOLS[f] }.join("")
    end
  end

  # Display type as html. If entypo is set to true,
  # will use entypo glyphs.
  def html_type(entypo:false)
    if entypo
      ENTYPO_SYMBOLS[type]
    else
      HTML_SYMBOLS[type]
    end
  end

  private
  def value_for_flag f
    if FLAGS.include?(f)
      2 ** FLAGS.index(f) 
    else
      nil
    end
  end

  def default_values
    update_attribute(:int_type, 0) if !int_type
    update_attribute(:int_flags, 0) if !int_flags
  end
end