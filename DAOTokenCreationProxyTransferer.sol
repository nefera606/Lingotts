import "./TokenCreation.sol";

contract DAOTokenCreationProxyTransferer {
    address public owner;
    address public dao;

    //constructor
    function DAOTokenCreationProxyTransferer(address _owner, address _dao) {
        owner = _owner;
        dao = _dao;

        // just in case somebody already added values to this address,
        // we will forward it right now.
        sendValues();
    }

    // default-function called when values are sent.
    function () {
       sendValues();
    }

    function sendValues() {
        if (this.balance == 0)
            return;

        TokenCreationInterface fueling = TokenCreationInterface(dao);
        if (now > fueling.closingTime() ||
            !fueling.createTokenProxy.value(this.balance)(owner)) {

           owner.send(this.balance);
        }
    }
}
