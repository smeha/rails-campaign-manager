import React from 'react'

class BannerItems extends React.Component {
  render() {
    return (
      <div className="app-card panel-card">
        <div className="table-responsive">
          <table className="table table-hover align-middle">
            <thead>
              <tr>
                <th scope="col">Name</th>
                <th scope="col">Text</th>
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
export default BannerItems
