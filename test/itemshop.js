const ItemShop = artifacts.require("ItemShop");

var accounts;
var owner;

contract('ItemShop', (accs) => {
    accounts = accs;
    owner = accounts[0];
});

it('deployed', async() => {
    let instance = await ItemShop.deployed();
    assert.equal(await instance.owner.call(), owner);
});

it('check initial count = 0', async() => {
  let instance = await ItemShop.deployed();
  assert.equal(await instance.skuCount.call(), 0);
});

it('can add item', async() => {
  let instance = await ItemShop.deployed();
  await instance.addItem("iphone", "100", {from: owner});
  let fItem = await instance.fetchItem(1);
  assert.equal(fItem.name,"iphone");
});

it('can buy item', async() => {
  let instance = await ItemShop.deployed();
  await instance.addItem("iphone", "100", {from: owner});

  await instance.buyItem(1, {from: accounts[1], value: 1000});
  let fItem = await instance.fetchItem(1);
  assert.equal(fItem.buyer,accounts[1]);
});