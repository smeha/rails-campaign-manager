import React from 'react'
import PropTypes from 'prop-types'

import axios from "axios";
import setAxiosHeaders from "./AxiosHeaders";

import Moment from 'moment';
class CampaignItem extends React.Component {
  constructor(props) {
    super(props)
    this.state = {
      startDate: Moment(this.props.campaignItem.start_date).format("MM/DD/yyyy"),
      endDate: Moment(this.props.campaignItem.end_date).format("MM/DD/yyyy"),
      startTime: this.props.campaignItem.start_time ? Moment.utc(this.props.campaignItem.start_time).format("h:mm a") : '',
      endTime: this.props.campaignItem.end_time ? Moment.utc(this.props.campaignItem.end_time).format("h:mm a") : '' ,
    };

    this.handleDestroy = this.handleDestroy.bind(this);
    this.path = `/deletecampaign/${this.props.campaignItem.id}`;
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

  render() {
    const { campaignItem } = this.props
    return (
      <tr className='table-light'>
        <td>
          <input
            type="text"
            defaultValue={campaignItem.name}
            disabled={true}
            className="form-control"
            id={`campaignItem__name-${campaignItem.id}`}
          />
        </td>
        <td>
          <input
            type="text"
            defaultValue={this.state.startDate}
            disabled={true}
            className="form-control"
            id={`campaignItem__start_date-${campaignItem.id}`}
          />
        </td>
        <td>
          <input
            type="text"
            defaultValue={this.state.endDate}
            disabled={true}
            className="form-control"
            id={`campaignItem__end_date-${campaignItem.id}`}
          />
        </td>
        <td>
          <input
            type="text"
            defaultValue={this.state.startTime}
            disabled={true}
            className="form-control"
            id={`campaignItem__start_time-${campaignItem.id}`}
          />
        </td>
        <td>
          <input
            type="text"
            defaultValue={this.state.endTime}
            disabled={true}
            className="form-control"
            id={`campaignItem__end_time-${campaignItem.id}`}
          />
        </td>
        <td className="text-right">          
          <button 
          onClick={this.handleDestroy}
          className="btn btn-outline-danger">Delete</button>
        </td>
      </tr>
    )
  }
}

export default CampaignItem

CampaignItem.propTypes = {
  campaignItem: PropTypes.object.isRequired,
  getCampaignItems: PropTypes.func.isRequired,
}