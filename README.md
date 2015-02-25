# react-modallink
Creates a modal and a link to open the modal

## Usage

### Create a react-component that contains a Modal

```javascript
# MyModal.jsx
var Modal = require('react-modallink').Modal;

var MyModal = React.createClass({
  render: function () {
    return (
      <Modal {...this.props}>
        <header>Modal</header>
        <p>{this.props.something}</p>
      </Modal>
    );
  }
});
```

### Include a link for it in another component

```javascript


var MyModal = require('./MyModal.jsx');
var ModalLink = require('react-modallink').ModalLink;

var ComponentWithModalLink = React.createClass({
  render: function () {
    return (
      <div>
        <ModalLink modal={<MyModal something="anything" />}>
          <a>Open modal</a>
        </ModalLink>
      </div>
    );
  }
});
```
