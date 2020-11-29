import React from 'react'
import ReactDOM from 'react-dom'
import axios from "axios";
import BannerItems from "./BannerItems";
import BannerItem from "./BannerItem";
import BannerAdd from "./BannerAdd";

class BannerApp extends React.Component {
	constructor(props) {
		super(props);
		this.state = {
			bannerItems: []
		};
		this.getBannerItems = this.getBannerItems.bind(this);
		this.createBannerItem = this.createBannerItem.bind(this);

	}

	componentDidMount() {
		this.getBannerItems();
	}

	createBannerItem(bannerItem) {
		const bannerItems = [bannerItem, ...this.state.bannerItems];
		this.setState({ bannerItems });
	}

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
  render() {
     return (
     	<>
	     <BannerAdd createBannerItem={this.createBannerItem} />
	      <BannerItems>
	        {this.state.bannerItems.map(bannerItem => (
	          <BannerItem 
	          key={bannerItem.id} 
	          bannerItem={bannerItem} 
	          getBannerItems={this.getBannerItems}
	          />
	        ))}
	      </BannerItems>
      </>
    );
  }
}

document.addEventListener('turbolinks:load', () => {
  const app = document.getElementById('banner-app')
  app && ReactDOM.render(<BannerApp />, app)
})