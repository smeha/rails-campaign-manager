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
			currentUser: null,
			campaignItems: []
		};
		this.getCampaignItems = this.getCampaignItems.bind(this);
		this.updateCurrentUser = this.updateCurrentUser.bind(this);
		this.createCampaignItem = this.createCampaignItem.bind(this);

	}

	componentDidMount() {
		this.updateCurrentUser();
	}
	componentDidUpdate(){		
		this.getCampaignItems();
	}
	createCampaignItem(campaignItem) {
		const campaignItems = [campaignItem, ...this.state.campaignItems];
		this.setState({ campaignItems });
	}
	updateCurrentUser() {
		axios.get('/getuserid',{
		}).then(response => {
			if(response.data.id){
				this.setState({ currentUser: response.data.id});
			}else{
				this.setState({ currentUser: null });
			}
		}).catch(function(error){
			console.log(error);
		})
	}

	getCampaignItems() {
		// NEED TO COME BACK TO THIS
		var cur_user_id  = this.state.currentUser;
		// axios.get('/getuserid',{
		// }).then(response => {
		// 	if(response.data.id){
		// 		testVarible = response.data.id;
		// 	}
		// }).catch(function(error){
		// 	console.log(error);
		// })		
		console.log(cur_user_id);
		axios
		.get("/showcampaign/"+cur_user_id)
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
	     <CampaignAdd createCampaignItem={this.createCampaignItem} />
	      <CampaignItems>
	        {this.state.campaignItems.map(campaignItem => (
	          <CampaignItem key={campaignItem.id} campaignItem={campaignItem} />
	        ))}
	      </CampaignItems>
      </>
    );
  }
}

document.addEventListener('turbolinks:load', () => {
  const app = document.getElementById('campaign-add')
  app && ReactDOM.render(<CampaignApp />, app)
})