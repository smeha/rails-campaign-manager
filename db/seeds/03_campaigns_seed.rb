demo_user = User.find_by_email('demo@example.com')
banner_1 = demo_user.banners.where(name: 'Banner 1').first
banner_2 = demo_user.banners.where(name: 'Banner 2').first
banner_3 = demo_user.banners.where(name: 'Banner 3').first

demo_user.campaigns.create(name: 'Campaign Banner 1', start_date: '30/11/2020', end_date: '5/12/2020', start_time: '10:00', end_time: '20:00', banners_id: banner_1.id)
demo_user.campaigns.create(name: 'Campaign Banner 3', start_date: '30/11/2020', end_date: '5/12/2020', start_time: '05:00', end_time: '12:00', banners_id: banner_3.id)
demo_user.campaigns.create(name: 'Campaign Banner 2', start_date: '30/11/2020', end_date: '5/12/2020', start_time: '14:00', end_time: '20:00', banners_id: banner_2.id)
demo_user.campaigns.create(name: 'Campaign Banner 2', start_date: '30/11/2020', end_date: '30/11/2020', start_time: '02:00', end_time: '04:00', banners_id: banner_2.id)
