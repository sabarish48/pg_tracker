module ItemHelper

  def users_form_column
    users_str = ""
    User.all.each do |user|
      users_str += "<br/>"
      users_str += check_box_tag "record[users][]", user.id
      users_str += "#{user.screen_name.titleize}"
    end
    users_str
  end

  def users_header_field(items)
    items_str = ""
    items.each do |item|
      label_tag("transaction", "Transaction Name".titleize)
    end    
    users_str = label_tag("transaction", "Transaction Name".titleize)
    users_str += label_tag("transaction", "TransactionDate".titleize)
    User.all.each do |user|
      users_str += label_tag("users_#{user.id}", user.screen_name.titleize)
    end
    content_tag(users_str)
  end

  def get_item_users(item)
    users_str = ""
    UserItem.find_all_by_item_id(item.id).each do |user_item|
       users_str += label_tag("transaction", User.find(user_item.user_id).screen_name.titleize)+"<br\>"
    end
    users_str
  end
end
