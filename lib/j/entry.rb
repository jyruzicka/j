class J::Entry < ActiveRecord::Base

  before_save :default_values

  #-------------------------------------------------------------------------------
  # Entry types and associated methods

  ENTRY_TYPES = %i(note event)
    
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

  FLAGS = %i(inspiration explore)

  def flags
    @flags ||= FLAGS.select{ |f| (int_flags & value_for_flag(f)) != 0 }
  end

  def add_flag f
    if FLAGS.include?(f)
      update_attribute(:int_flags, int_flags | value_for_flag(f))
    end
  end

  def to_s
    s = ""
    if !flags.empty?
      s << "[" << flags.map{ |sf| sf.to_s[0] }.join("") << "]"
    end
    s << (event? ? "O" : ".") << " " << body
    s
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