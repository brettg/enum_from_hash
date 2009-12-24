module EnumFromHash
  def enum_from_hash(field, hash)
    const_set(field.to_s.pluralize.upcase, hash)
    consts_from_hash(hash)

    begin
      col = if column_names.include?(field.to_s)
        field
      elsif column_names.include?(field_id = "#{field}_id")
        field_id
      else
        raise "given field #{field} does not correspond to db column"
      end
    rescue ActiveRecord::StatementInvalid
      # this might get loaded before the table exists
      # as in a migration
      # just pass through here to let migration run
      return
    end
      
    validates_inclusion_of col, :in => hash.values
    
    class_eval do
      define_method("#{field}=") do |new_val|
        self[col] = case new_val
        when Symbol
          hash[new_val]
        when String
          if new_val.strip[/^\d$/]
            new_val.to_i
          else
            hash[new_val.to_sym]
          end
        else
          new_val
        end
      end
      define_method("#{field}_name") do
        hash.invert[self[col]].to_s
      end
      unless col == field
        alias_method field, "#{field}_name"
      end
      hash.each do |k, v|
        define_method("#{k}?") do
          self[col] == v
        end
      end
    end
  end
  def consts_from_hash(hsh)
    hsh.each {|k, v| const_set(k.to_s.upcase, v)}
  end
end
ActiveRecord::Base.extend EnumFromHash