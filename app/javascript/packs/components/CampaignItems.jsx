import React from 'react'

class CampaignItems extends React.Component {
  render() {
    return (
      <div className="app-card panel-card">
        <div className="table-responsive">
          <table className="table table-hover align-middle">
            <thead>
              <tr>
                <th scope="col">Name</th>
                <th scope="col">Start Date</th>
                <th scope="col">End Date</th>
                <th scope="col">Start Time</th>
                <th scope="col">End Time</th>
                <th scope="col">Banner Name</th>
                <th scope="col" className="text-center">Delete</th>
              </tr>
            </thead>
            <tbody>{this.props.children}</tbody>
          </table>
        </div>
      </div>
    )
  }
}
export default CampaignItems
