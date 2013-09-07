class J::Entry < ActiveRecord::Base

  has_and_belongs_to_many :tags, :join_table => "taggings"

  before_save :default_values

  #-------------------------------------------------------------------------------
  # Assorted constants

  ENTRY_TYPES = %i(note event)

  ENTYPO_SYMBOLS = {
    note: "&#128196;",
    event: "&#128197;",
  }

  HTML_SYMBOLS = {
    note: "&bull;",
    event: "&empty;",
  }

  TEXT_SYMBOLS = {
    note: "•",
    event: "O",
  }


  #-------------------------------------------------------------------------------
  # Entry types and associated methods
  
  # Retrieve symbol form of entry type
  def entry_type
    @entry_type ||= ENTRY_TYPES[int_type]
  end

  # Set entry type using a symbol
  def entry_type= e
    self.update_attribute(:int_type, ENTRY_TYPES.index(e)) if ENTRY_TYPES.include?(e)
  end

  # Is this an event?
  def event?
    entry_type == :event
  end

  # Is this a note?
  def note?
    entry_type == :note
  end

  #-------------------------------------------------------------------------------
  # Tag-related methods

  # Does this entry have this tag?
  def has_tag?(t)
    tags.include?(t)
  end

  # Add a tag
  def add_tag(t)
    t = J::Tag.find_or_create_by(name: t) if t.is_a? String
    tags << t
  end

  # Remove a tag
  def remove_sticker(t)
    t = J::Tag.find_by(name: t) if t.is_a? String
    tags.delete(t) if t
  end

  # Determine tags based on an entry's body text
  def auto_tag!
    tags = self.body.scan(/(?<=#)\S+/).map{ |ts| J::Tag.find_or_create_by(name: ts) }
    self.tags = tags
  end

  #-------------------------------------------------------------------------------
  # Other functions
  #-------------------------------------------------------------------------------

  # Convert the entry to a string
  def to_s
    TEXT_SYMBOLS[self.entry_type] + 
    "] " +
    body
  end

  # Convert the entry to html.
  # Uses html symbols to represent and entries, and parses
  # the body through markdown before displaying. If you pass
  # :entypo=true, it will use entypo glyphs for entry types.
  def to_html(entypo: false)
    html_type(entypo:entypo) + " " + html_body(inline:true)
  end

  # Display type as html. If entypo is set to true,
  # will use entypo glyphs.
  def html_type(entypo:false)
    if entypo
      ENTYPO_SYMBOLS[entry_type]
    else
      HTML_SYMBOLS[entry_type]
    end
  end

  # Display body as html. If inline is set to true, will remove
  # paragraph markers
  def html_body(inline:false)
    html_body = Kramdown::Document.new(body).to_html
    html_body.gsub!(/<\/?p>/,'') if inline
    html_body
  end

  private

  def default_values
    update_attribute(:int_type, 0) if !int_type
  end
end