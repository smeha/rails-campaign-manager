import React, {useState} from 'react'
import PropTypes from 'prop-types'

import axios from 'axios'
import setAxiosHeaders from "./AxiosHeaders";

import DatePicker from "react-datepicker"; 
import "react-datepicker/dist/react-datepicker.css";

import Moment from 'moment';

class CampaignAdd extends React.Component {
  constructor(props) {
    super(props)
    this.state = {
      startDate: new Date(),
      endDate: new Date(),
      startTime: new Date(),
      endTime: new Date(),
    };
    this.handleSubmit = this.handleSubmit.bind(this);
    this.nameRef = React.createRef();
    this.banneridRef = React.createRef();
    this.handleChangeStartDate = this.handleChangeStartDate.bind(this);  
    this.handleChangeEndDate = this.handleChangeEndDate.bind(this); 
    this.handleChangeStartTime = this.handleChangeStartTime.bind(this); 
    this.handleChangeEndTime = this.handleChangeEndTime.bind(this); 
  }

  handleSubmit(e) {
    e.preventDefault();
    setAxiosHeaders();
    axios
      .post('/newcampaign', {
        campaign: {
          name: this.nameRef.current.value,
          end_date: Moment(this.state.endDate).format("DD/MM/yyyy"),          
          start_date: Moment(this.state.startDate).format("DD/MM/yyyy"),
          start_time: Moment(this.state.startTime).format("HH:mm"),
          end_time: Moment(this.state.endTime).format("HH:mm"),
          banners_id: this.banneridRef.current.value,
        },
      })
      .then(response => {
        const campaignItem = response.data
        this.props.createCampaignItem(campaignItem)
      })
      .catch(error => {
        console.log(error)
      })
    e.target.reset()
  }

  handleChangeStartDate(date) {
    this.setState({
      startDate: date
    });
  }

  handleChangeEndDate(date) {
    this.setState({
      endDate: date
    });
  }
  handleChangeStartTime(date){
    this.setState({
      startTime: date
    });
  }
  handleChangeEndTime(date){
    this.setState({
      endTime: date
    });
  }
  render() {
    return (
      <form onSubmit={this.handleSubmit} className="my-3 mx-4">
        <div className="form-row">
          <div className="form-group col-md-6">
            <input
              type="text"
              name="name"
              ref={this.nameRef}
              required
              className="form-control"
              id="name"
              placeholder="Campaign name"
            />
          </div> 
          <div className="form-group col-md-5">
            <button className="btn btn-outline-success btn-block">
              Add Campaign
            </button>
          </div>
        </div>
        <div className="form-row form-inline">
        <div className="form-group col-md-2"> 
            <label className="mx-1">Select Banner</label>   
            <select name="banners_id" ref={this.banneridRef} className="form-control" required>
                {this.props.bannerItems.map((obj) => {
                     return <option key={obj.id} value={obj.id}>{obj.name}</option>
                 })}
             </select>    
        </div>
        <div className="form-group col-md-2">
            <label className="mx-1">Start Date</label>
            <DatePicker
              selected={ this.state.startDate }
              onChange={this.handleChangeStartDate }
              name="start_date"
              minDate={Moment().toDate()}
              required
              dateFormat="MM/dd/yyyy"
            />
          </div>
          <div className="form-group col-md-2">
            <label className="mx-1">End Date</label>
            <DatePicker
              selected={ this.state.endDate }
              onChange={ this.handleChangeEndDate }
              name="end_date"
              minDate={Moment().toDate()}
              required
              dateFormat="MM/dd/yyyy"
            />
          </div>
          <div className="form-group col-md-2">
            <label className="mx-1">Start Time</label>
            <DatePicker
              selected={this.state.startTime}
              onChange={this.handleChangeStartTime}
              showTimeSelect
              showTimeSelectOnly
              timeIntervals={15}
              timeCaption="Time"
              dateFormat="h:mm aa"
            />
          </div>
          <div className="form-group col-md-2">
            <label className="mx-1">End Time</label>
            <DatePicker
              selected={this.state.endTime}
              onChange={this.handleChangeEndTime}
              showTimeSelect
              showTimeSelectOnly
              timeIntervals={15}
              timeCaption="Time"
              dateFormat="h:mm aa"
            />
          </div>
        </div>
      </form>
    )
  }
}

export default CampaignAdd

CampaignAdd.propTypes = {
  createCampaignItem: PropTypes.func.isRequired,
}