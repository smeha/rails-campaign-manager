import React from 'react'
import PropTypes from 'prop-types'

import axios from "axios";
import setAxiosHeaders from "./AxiosHeaders";

import Moment from 'moment';
class CampaignItem extends React.Component {
  constructor(props) {
    super(props)
    this.state = {
      startDate: Moment(this.props.campaignItem.start_date).format("MM/DD/YYYY"),
      endDate: Moment(this.props.campaignItem.end_date).format("MM/DD/YYYY"),
      startTime: this.props.campaignItem.start_time ? Moment.utc(this.props.campaignItem.start_time).format("h:mm a") : '',
      endTime: this.props.campaignItem.end_time ? Moment.utc(this.props.campaignItem.end_time).format("h:mm a") : '' ,
    };

    this.handleDestroy = this.handleDestroy.bind(this);
    this.getBannerName = this.getBannerName.bind(this);
    this.path = `/api/v1/campaigns/${this.props.campaignItem.id}`;
  }

  handleDestroy() {
    setAxiosHeaders();
    const confirmation = confirm("Delete '"+this.props.campaignItem.name+"'?");
    if (confirmation) {
      axios.delete(this.path)
        .then(response => {
          this.props.getCampaignItems();
        })
        .catch(error => {
          console.log(error);
        });
    }
  }
  getBannerName(idToSearch) {
    let temp =  this.props.bannerItems.filter(item => {
      return item.id === Number(idToSearch)
    });
    if(temp[0]){
      return temp[0].name;
    }else{
      return '';
    }
    
  };
  render() {
    const { campaignItem } = this.props
    return (
      <tr>
        <td>
          <span id={`campaignItem__name-${campaignItem.id}`}>{campaignItem.name}</span>
        </td>
        <td>
          <span id={`campaignItem__start_date-${campaignItem.id}`}>{this.state.startDate}</span>
        </td>
        <td>
          <span id={`campaignItem__end_date-${campaignItem.id}`}>{this.state.endDate}</span>
        </td>
        <td>
          <span id={`campaignItem__start_time-${campaignItem.id}`}>{this.state.startTime}</span>
        </td>
        <td>
          <span id={`campaignItem__end_time-${campaignItem.id}`}>{this.state.endTime}</span>
        </td>
        <td>
          <span id={`campaignItem__banner_name-${campaignItem.id}`}>{this.getBannerName(campaignItem.banner_id)}</span>
        </td>
        <td className="text-end">
          <button 
          onClick={this.handleDestroy}
          className="btn btn-sm btn-outline-danger">Delete</button>
        </td>
      </tr>
    )
  }
}

export default CampaignItem

CampaignItem.propTypes = {
  campaignItem: PropTypes.object.isRequired,
  bannerItems: PropTypes.array.isRequired,
  getCampaignItems: PropTypes.func.isRequired,
}
