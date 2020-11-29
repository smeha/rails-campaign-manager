import React from 'react'
import PropTypes from 'prop-types'

import axios from "axios";
import setAxiosHeaders from "./AxiosHeaders";

class BannerItem extends React.Component {
  constructor(props) {
    super(props)

    this.handleDestroy = this.handleDestroy.bind(this);
    this.path = `/deletebanner/${this.props.bannerItem.id}`;
  }

  handleDestroy() {
    setAxiosHeaders();
    const confirmation = confirm("Delete '"+this.props.bannerItem.name+"'?");
    if (confirmation) {
      axios.delete(this.path)
        .then(response => {
          this.props.getBannerItems();
        })
        .catch(error => {
          console.log(error);
        });
    }
  }

  render() {
    const { bannerItem } = this.props
    return (
      <tr className='table-light'>
        <td>
          <span id={`bannerItem__name-${bannerItem.id}`} >{bannerItem.name}</span>
        </td>
        <td>
          <p className="text-break" >
          {bannerItem.text}
          </p>
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

export default BannerItem

BannerItem.propTypes = {
  bannerItem: PropTypes.object.isRequired,
  getBannerItems: PropTypes.func.isRequired,
}