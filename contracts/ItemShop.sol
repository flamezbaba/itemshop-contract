// SPDX-License-Identifier: UNLISCENSED
pragma solidity ^0.5.16;

contract ItemShop{
    
   address public owner;
   
   uint256 public skuCount;
   
   enum State{ Forsale, Sold }
    
    struct Item{
        string name;
        uint256 sku;
        uint256 price;
        State state;
        address seller;
        address buyer;
    }
    
    mapping(uint256 => Item) items;
    
    event Forsale(uint256 sku);
    
    event Sold(uint256 sku);
    
    modifier onlyOwner(){
        require(msg.sender == owner, "only owner is allowed");
        _;
    }
    
    modifier verifyCaller(address _address){
        require(msg.sender == _address);
        _;
    }
    
    modifier paidEnough(uint256 _price){
        require(msg.value >= _price, "insufficent funds");
        _;
    }
    
    modifier forSale(uint256 _sku){
        require(items[_sku].state == State.Forsale, "not for sale");
        _;
    }
    
    modifier sold(uint256 _sku){
        require(items[_sku].state == State.Sold, "already sold");
        _;
    }
    
    constructor() public payable{
        owner = msg.sender;
        skuCount = 0;
    }
    
    function addItem(string memory _name, uint256 _price) onlyOwner public{
        skuCount = skuCount + 1;
        
        emit Forsale(skuCount);
        
        items[skuCount] = Item({
            name: _name,
            sku: skuCount,
            price: _price,
            state: State.Forsale,
            seller: msg.sender,
            buyer: address(0)
        });
    }
    
    function buyItem(uint256 _sku) forSale(_sku) paidEnough(items[_sku].price) public payable{
        address buyer = msg.sender;
        
        items[_sku].state = State.Sold;
        items[_sku].buyer = buyer;
        uint256 _price = items[_sku].price;
        
        address payable _seller = address(uint160(items[_sku].seller));
        _seller.transfer(_price);
        
        emit Sold(_sku);
    }
    
    function fetchItem(uint256 _sku) public view returns(string memory name, uint256 sku, uint256 price, string memory stateRes, address seller, address buyer){
        name = items[_sku].name;
        sku = items[_sku].sku;
        price = items[_sku].price;
        seller = items[_sku].seller;
        buyer = items[_sku].buyer;
        uint256 _state = uint256(items[_sku].state);
        if(_state == 0){
            stateRes = "For Sale";
        }
        
        if(_state == 1){
            stateRes = "Sold";
        }
    }
}