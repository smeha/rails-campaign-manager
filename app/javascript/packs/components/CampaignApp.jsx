import React from 'react'
import ReactDOM from 'react-dom'
import axios from "axios";
import CampaignItems from "./CampaignItems";
import CampaignItem from "./CampaignItem";
import CampaignAdd from "./CampaignAdd";

class CampaignApp extends React.Component {
	constructor(props) {
		super(props);
		this.state = {
			// currentUser: null,
			campaignItems: [],
			bannerItems: []
		};
		this.getCampaignItems = this.getCampaignItems.bind(this);
		this.getBannerItems = this.getBannerItems.bind(this);
		// this.updateCurrentUser = this.updateCurrentUser.bind(this);
		this.createCampaignItem = this.createCampaignItem.bind(this);

	}

	componentDidMount() {
		// this.updateCurrentUser();
		this.getCampaignItems();
		this.getBannerItems();
	}
	componentDidUpdate(){		
		// this.getCampaignItems();
	}
	createCampaignItem(campaignItem) {
		const campaignItems = [campaignItem, ...this.state.campaignItems];
		this.setState({ campaignItems });
	}
	// updateCurrentUser() {
	// 	axios.get('/getuserid',{
	// 	}).then(response => {
	// 		if(response.data.id){
	// 			this.setState({ currentUser: response.data.id});
	// 		}else{
	// 			this.setState({ currentUser: null });
	// 		}
	// 	}).catch(function(error){
	// 		console.log(error);
	// 	})
	// }

	getBannerItems() {
		axios.get("/showbanner/")
		.then(response => {
			const bannerItems = response.data;
			this.setState({ bannerItems });
		})
		.catch(error => {
			console.log(error);
		});
	}

	getCampaignItems() {
		axios.get("/showcampaign/")
		.then(response => {
			const campaignItems = response.data;
			this.setState({ campaignItems });
		})
		.catch(error => {
			console.log(error);
		});
	}
  render() {
     return (
     	<>
	     <CampaignAdd 
		     createCampaignItem={this.createCampaignItem} 
		     bannerItems={this.state.bannerItems} 
	     />
	      <CampaignItems>
	        {this.state.campaignItems.map(campaignItem => (
	          <CampaignItem 
	          key={campaignItem.id} 
	          campaignItem={campaignItem}
	          bannerItems={this.state.bannerItems}
	          getCampaignItems={this.getCampaignItems}
	          />
	        ))}
	      </CampaignItems>
      </>
    );
  }
}

document.addEventListener('turbolinks:load', () => {
  const app = document.getElementById('campaign-app')
  app && ReactDOM.render(<CampaignApp />, app)
})