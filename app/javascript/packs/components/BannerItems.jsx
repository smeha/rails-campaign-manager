import React from 'react'

class BannerItems extends React.Component {
  constructor(props) {
    super(props)
  }

  render() {
    return (
      <>
        <div className="table-responsive">
          <table className="table">
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
      </>
    )
  }
}
export default BannerItems