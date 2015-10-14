jest.dontMock('../Modal');
jest.dontMock('classnames');
jest.dontMock('react-addons-test-utils');

describe('Modal', function() {
  var React = require('react');
  var Modal = require('../Modal');
  var TestUtils = require('react-addons-test-utils');

  it('should have hidden as class when passed prop visible=false', function() {
    var modal = TestUtils.renderIntoDocument(<Modal visible={false} />);
    var withClassHidden = TestUtils.scryRenderedDOMComponentsWithClass(modal, "hidden");
    expect(withClassHidden.length).toBe(1);
  });

  it('should not have hidden as class when passed prop visible=true', function() {
    var modal = TestUtils.renderIntoDocument(<Modal visible={true} />);
    var withClassHidden = TestUtils.scryRenderedDOMComponentsWithClass(modal, "hidden");
    expect(withClassHidden.length).toBe(0);
  });

  it('should close when overlay is clicked', function() {
    var modal = TestUtils.renderIntoDocument(<Modal visible={true} />);
    var overlay = modal.refs.overlay;
    TestUtils.Simulate.click(overlay);
    var withClassHidden = TestUtils.scryRenderedDOMComponentsWithClass(modal, "hidden");
    expect(withClassHidden.length).toBe(1);
  });

  it('should not open when overlay is clicked after being hidden', function() {
    var modal = TestUtils.renderIntoDocument(<Modal visible={true} />);
    var overlay = modal.refs.overlay;
    TestUtils.Simulate.click(overlay);
    var withClassHidden = TestUtils.scryRenderedDOMComponentsWithClass(modal, "hidden");
    expect(withClassHidden.length).toBe(1);

    TestUtils.Simulate.click(overlay);
    withClassHidden = TestUtils.scryRenderedDOMComponentsWithClass(modal, "hidden");
    expect(withClassHidden.length).toBe(1);
  });

  it('should contain passed down classes, and overlay', function() {
    var modal = TestUtils.renderIntoDocument(<Modal visible={true} className="donald duck"/>);
    var withClassDonald = TestUtils.scryRenderedDOMComponentsWithClass(modal, "donald");
    expect(withClassDonald.length).toBe(1);
    var withClassDuck = TestUtils.scryRenderedDOMComponentsWithClass(modal, "duck");
    expect(withClassDuck.length).toBe(1);
    var withClassOverlay = TestUtils.scryRenderedDOMComponentsWithClass(modal, "overlay");
    expect(withClassOverlay.length).toBe(1);
  });



});
