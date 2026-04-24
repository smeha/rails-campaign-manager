import React from 'react'
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
      <form onSubmit={this.handleSubmit} className="app-card panel-card">
        <div className="d-flex flex-column flex-lg-row justify-content-between align-items-lg-end gap-3 mb-3">
          <div>
            <p className="hero-kicker mb-1">Create Banner</p>
            <h2 className="h4 mb-0">Banner text library</h2>
          </div>
        </div>
        <div className="row g-3 align-items-end">
          <div className="col-lg-3">
            <label htmlFor="banner-name" className="form-label">Name</label>
            <input
              type="text"
              name="name"
              ref={this.nameRef}
              required
              className="form-control"
              id="banner-name"
              placeholder="Banner name"
            />
          </div>
          <div className="col-lg-7">
            <label htmlFor="banner-text" className="form-label">Text</label>
            <input
              type="text"
              name="text"
              ref={this.textRef}
              required
              className="form-control"
              id="banner-text"
              placeholder="Banner text"
            />
          </div>
          <div className="col-lg-2 d-grid">
            <button className="btn btn-outline-success w-100">
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
