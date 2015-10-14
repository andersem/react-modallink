'use strict';

var React = require('react');

module.exports = React.createClass({
  getInitialState: function () {
    return {
      isModalShown: false
    };
  },

  show: function () {
    this.setState({
      isModalShown: true
    });
  },

  hide: function () {
    this.setState({
      isModalShown: false
    });
  },
  onTriggerClick: function (e) {
    e.preventDefault();
    e.stopPropagation();
    this.show();
  },
  render: function () {
    var triggerStyle = {
      cursor: 'pointer'
    };
    var passedTrigger = React.Children.only(this.props.children);
    var trigger = React.cloneElement(passedTrigger, {onClick: this.onTriggerClick});
    var modal = React.cloneElement(this.props.modal, {visible: this.state.isModalShown, onHide: this.hide});
    return (
      <div>
        {modal}
        <span style={triggerStyle}>
        {trigger}
        </span>
      </div>
    );
  }
});
