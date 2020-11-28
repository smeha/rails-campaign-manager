import React from 'react'
import PropTypes from 'prop-types'

import axios from 'axios'
import setAxiosHeaders from "./AxiosHeaders";
class CampaignAdd extends React.Component {
  constructor(props) {
    super(props)
    this.handleSubmit = this.handleSubmit.bind(this)
    this.nameRef = React.createRef()
  }

  handleSubmit(e) {
    e.preventDefault()
    setAxiosHeaders();
    axios
      .post('/newcampaign', {
        campaign: {
          name: this.nameRef.current.value,
          end_date: '03/03/2020',          
          start_date: '09/09/2020',
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

  render() {
    return (
      <form onSubmit={this.handleSubmit} className="my-3">
        <div className="form-row">
          <div className="form-group col-md-8">
            <input
              type="text"
              name="name"
              ref={this.nameRef}
              required
              className="form-control"
              id="name"
              placeholder="Write your campaign item here..."
            />
          </div>
          <div className="form-group col-md-4">
            <button className="btn btn-outline-success btn-block">
              Add To Do Item
            </button>
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