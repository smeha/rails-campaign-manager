import React from 'react'
import PropTypes from 'prop-types'

import axios from 'axios'
import setAxiosHeaders from "./AxiosHeaders";

import DatePicker from "react-datepicker"; 
import "react-datepicker/dist/react-datepicker.css";

import Moment from 'moment';

const normalizeToHour = (date) => {
  const normalizedDate = new Date(date)
  normalizedDate.setMinutes(0, 0, 0)
  return normalizedDate
}

const addHours = (date, hours) => {
  const nextDate = new Date(date)
  nextDate.setHours(nextDate.getHours() + hours)
  return nextDate
}

class CampaignAdd extends React.Component {
  constructor(props) {
    super(props)
    const currentHour = normalizeToHour(new Date())
    this.state = {
      startDate: currentHour,
      endDate: currentHour,
      startTime: currentHour,
      endTime: addHours(currentHour, 1),
      errors: [],
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
    this.setState({ errors: [] });
    setAxiosHeaders();
    axios
      .post('/api/v1/campaigns', {
        campaign: {
          name: this.nameRef.current.value,
          end_date: Moment(this.state.endDate).format("YYYY-MM-DD"),
          start_date: Moment(this.state.startDate).format("YYYY-MM-DD"),
          start_time: Moment(this.state.startTime).format("HH:mm"),
          end_time: Moment(this.state.endTime).format("HH:mm"),
          banner_id: this.banneridRef.current.value,
        },
      })
      .then(response => {
        const campaignItem = response.data
        this.setState({
          errors: [],
          startDate: normalizeToHour(new Date()),
          endDate: normalizeToHour(new Date()),
          startTime: normalizeToHour(new Date()),
          endTime: addHours(normalizeToHour(new Date()), 1),
        })
        this.props.createCampaignItem(campaignItem)
        this.nameRef.current.value = ""
      })
      .catch(error => {
        const errors = error.response?.data?.errors || [ "Unable to create campaign." ]
        this.setState({ errors })
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
    const nextStartTime = normalizeToHour(date)
    const nextEndTime = this.state.endTime <= nextStartTime ? addHours(nextStartTime, 1) : this.state.endTime
    this.setState({
      startTime: nextStartTime,
      endTime: nextEndTime
    });
  }
  handleChangeEndTime(date){
    this.setState({
      endTime: normalizeToHour(date)
    });
  }
  render() {
    return (
      <form onSubmit={this.handleSubmit} className="app-card panel-card">
        <div className="d-flex flex-column flex-lg-row justify-content-between align-items-lg-end gap-3 mb-3">
          <div>
            <p className="hero-kicker mb-1">Create Campaign</p>
            <h2 className="h4 mb-0">Schedule a banner campaign</h2>
          </div>
        </div>
        {this.state.errors.length > 0 && (
          <div className="alert alert-danger" role="alert">
            <ul className="mb-0 ps-3">
              {this.state.errors.map((error) => (
                <li key={error}>{error}</li>
              ))}
            </ul>
          </div>
        )}
        <div className="row g-3">
          <div className="col-lg-6">
            <label htmlFor="campaign-name" className="form-label">Name</label>
            <input
              type="text"
              name="name"
              ref={this.nameRef}
              required
              className="form-control"
              id="campaign-name"
              placeholder="Campaign name"
            />
          </div> 
          <div className="col-lg-3">
            <label htmlFor="campaign-banner" className="form-label">Banner</label>
            <select id="campaign-banner" name="banner_id" ref={this.banneridRef} className="form-select" required>
                {this.props.bannerItems.map((obj) => {
                     return <option key={obj.id} value={obj.id}>{obj.name}</option>
                 })}
             </select>
          </div>
          <div className="col-lg-3 d-grid">
            <label className="form-label d-none d-lg-block">&nbsp;</label>
            <button className="btn btn-outline-success w-100">
              Add Campaign
            </button>
          </div>
          <div className="col-md-6 col-lg-3">
            <label className="form-label">Start Date</label>
            <DatePicker
              selected={ this.state.startDate }
              onChange={this.handleChangeStartDate }
              name="start_date"
              minDate={Moment().toDate()}
              required
              dateFormat="MM/dd/yyyy"
              className="form-control"
            />
          </div>
          <div className="col-md-6 col-lg-3">
            <label className="form-label">End Date</label>
            <DatePicker
              selected={ this.state.endDate }
              onChange={ this.handleChangeEndDate }
              name="end_date"
              minDate={Moment().toDate()}
              required
              dateFormat="MM/dd/yyyy"
              className="form-control"
            />
          </div>
          <div className="col-md-6 col-lg-3">
            <label className="form-label">Start Time</label>
            <DatePicker
              selected={this.state.startTime}
              onChange={this.handleChangeStartTime}
              showTimeSelect
              showTimeSelectOnly
              timeIntervals={60}
              timeCaption="Time"
              dateFormat="h:mm aa"
              className="form-control"
            />
          </div>
          <div className="col-md-6 col-lg-3">
            <label className="form-label">End Time</label>
            <DatePicker
              selected={this.state.endTime}
              onChange={this.handleChangeEndTime}
              showTimeSelect
              showTimeSelectOnly
              timeIntervals={60}
              timeCaption="Time"
              dateFormat="h:mm aa"
              className="form-control"
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
