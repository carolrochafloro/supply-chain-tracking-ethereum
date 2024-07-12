// SPDX-License-Identifier: MIT

pragma solidity ^0.8.26;

contract ProductTracking {

      struct Product {
        string id;
        string name;
        address[] owners;
    }
    // cria uma espécie de hashmap ou dicionário com os produtos, armazenando o id como string
    mapping(string => Product) private products;
    mapping(string => bool) private productExists;

    event ProductCreated(string id, string name, address owner);
    event ProductTransferred(string id, address from, address to);

    modifier onlyExistingProduct(string memory productId) {
        require(productExists[productId], "Product does not exist");
        _;
    }

        function createProduct(string memory productId, string memory name) public {
        require(!productExists[productId], "Product already exists");
        
       address[] memory owners = new address[](1);
        owners[0] = msg.sender;
        
        products[productId] = Product({
            id: productId,
            name: name,
            owners: owners
        });
        
        productExists[productId] = true;
        
        emit ProductCreated(productId, name, msg.sender);
    }

    function transferProduct(string memory productId, address newOwner) public onlyExistingProduct(productId) {
        Product storage product = products[productId];
        require(product.owners[product.owners.length - 1] == msg.sender, "Only the current owner can transfer the product");

        product.owners.push(newOwner);
        
        emit ProductTransferred(productId, msg.sender, newOwner);
    }

        function getProductOwners(string memory productId) public view onlyExistingProduct(productId) returns (address[] memory) {
        return products[productId].owners;
    }

    function getProductDetails(string memory productId) public view onlyExistingProduct(productId) returns (string memory, string memory, address[] memory) {
        Product storage product = products[productId];
        return (product.id, product.name, product.owners);
    }
}

