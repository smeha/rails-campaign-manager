demo_user = User.find_by_email('demo@example.com')

demo_user.banners.create(name: 'Banner 1', text: 'Long text for banner 1. Long text for banner 1. Long text for banner 1. Long text for banner 1. ')
demo_user.banners.create(name: 'Banner 2', text: 'Long text for banner 2. Long text for banner 2. Long text for banner 2. Long text for banner 2. Long text for banner 2. Long text for banner 2. ')
demo_user.banners.create(name: 'Banner 3', text: 'Long text for banner 3. Long text for banner 3. Long text for banner 3. Long text for banner 3. Long text for banner 3. Long text for banner 3. Long text for banner 3. Long text for banner 3. ')
