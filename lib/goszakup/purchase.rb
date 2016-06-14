module Goszakup
  Purchase = Struct.new :purchase_id, :permalink_id, :title, :owner, :price,
    :publish_datetime, :due_datetime do
  end
end
