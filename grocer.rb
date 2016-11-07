def consolidate_cart(cart)
  list = {}
  	cart.each do |items|
    	items.each do |name, value|
      	unless list[name]
        	list[name] = value
        	list[name][:count] = 0
      	end
      	list[name][:count] += 1
    	end
  	end
  list
end

def apply_coupons(cart, coupons)
  coupons.each do |coupon|
    name = coupon[:item]
    if cart[name] && cart[name][:count] >= coupon[:num]
      if cart["#{name} W/COUPON"]
         cart["#{name} W/COUPON"][:count] += 1
      else
        cart["#{name} W/COUPON"] = {:count => 1, :price => coupon[:cost]}
        cart["#{name} W/COUPON"][:clearance] = cart[name][:clearance]
      end
      cart[name][:count] -= coupon[:num]
    end
  end
  cart
end

def apply_clearance(cart)
  cart.each do |name, data|
    if data[:clearance]
      reduced_price = data[:price] * 0.80
      data[:price] = reduced_price.round(2)
    end
  end
  cart
end

def checkout(cart, coupons)
  consolidated_cart = consolidate_cart(cart)
  coupon_cart = apply_coupons(consolidated_cart, coupons)
  final_cart = apply_clearance(coupon_cart)
  total = 0
  	final_cart.each do |name, data|
    	total += data[:price] * data[:count]
  	end
  total = total * 0.9 if total > 100
  total
end
