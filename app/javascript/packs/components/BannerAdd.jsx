import React, {useState} from 'react'
import PropTypes from 'prop-types'

import axios from 'axios'
import setAxiosHeaders from "./AxiosHeaders";

class BannerAdd extends React.Component {
  constructor(props) {
    super(props)
    this.handleSubmit = this.handleSubmit.bind(this);
    this.nameRef = React.createRef();
    this.textRef = React.createRef();
  }

  handleSubmit(e) {
    e.preventDefault();
    setAxiosHeaders();
    axios
      .post('/newbanner', {
        banner: {
          name: this.nameRef.current.value,
          text: this.textRef.current.value,
        },
      })
      .then(response => {
        const bannerItem = response.data
        this.props.createBannerItem(bannerItem)
      })
      .catch(error => {
        console.log(error)
      })
    e.target.reset()
  }

  render() {
    return (
      <form onSubmit={this.handleSubmit} className="my-3 mx-4">
        <div className="form-row">
          <div className="form-group col-md-2">
            <input
              type="text"
              name="name"
              ref={this.nameRef}
              required
              className="form-control"
              id="name"
              placeholder="Banner name"
            />
            </div>
            <div className="form-group col-md-8">
            <input
              type="text"
              name="text"
              ref={this.textRef}
              required
              className="form-control"
              id="text"
              placeholder="Banner text"
            />
          </div>
          <div className="form-group col-md-2">
            <button className="btn btn-outline-success btn-block">
              Add Banner
            </button>
          </div>
        </div>        
      </form>
    )
  }
}

export default BannerAdd

BannerAdd.propTypes = {
  createBannerItem: PropTypes.func.isRequired,
}