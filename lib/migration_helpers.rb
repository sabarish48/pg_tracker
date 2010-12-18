module MigrationHelpers
  def foreign_key(from_table, from_column, to_table = nil)
    from_column = from_column.to_s
    to_table ||= from_column[0..(from_column.length-4)].pluralize
    constraint_name = "fk_#{from_table}_#{from_column}"

    execute %{alter table #{from_table}
              add constraint #{constraint_name}
              foreign key (#{from_column})
              references #{to_table}(id)}
  end

 def remove_foreign_key(from_table, from_column)
   constraint_name = "fk_#{from_table}_#{from_column}"

   execute %{alter table #{from_table}
             drop foreign key #{constraint_name}}
 end

end