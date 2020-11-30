test_user = User.find_by_email('test@test.com')
banner_1 = test_user.banners.where(name: 'Banner 1').first
banner_2 = test_user.banners.where(name: 'Banner 2').first
banner_3 = test_user.banners.where(name: 'Banner 3').first

test_user.campaigns.create(name: 'Campaign Banner 1 No Time',start_date: '30/11/2020',end_date: '5/12/2020', banners_id: banner_1.id)
test_user.campaigns.create(name: 'Campaign Banner 2 No Time',start_date: '30/11/2020',end_date: '5/12/2020', banners_id: banner_2.id)
test_user.campaigns.create(name: 'Campaign Banner 1',start_date: '30/11/2020',end_date: '5/12/2020',start_time: '10:00', end_time: '20:00', banners_id: banner_1.id)
test_user.campaigns.create(name: 'Campaign Banner 3',start_date: '30/11/2020',end_date: '5/12/2020',start_time: '05:00', end_time: '12:00', banners_id: banner_3.id)
test_user.campaigns.create(name: 'Campaign Banner 2',start_date: '30/11/2020',end_date: '5/12/2020',start_time: '14:00', end_time: '20:00', banners_id: banner_2.id)
test_user.campaigns.create(name: 'Campaign Banner 2',start_date: '30/11/2020',end_date: '30/11/2020',start_time: '02:00', end_time: '04:00', banners_id: banner_2.id)
