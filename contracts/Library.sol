// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

contract Library{
   struct Book{
    uint id;
    string name;
    uint year;
    string author;
    bool finished;
   }

    Book[] private bookList;

    mapping(uint256=>address) bookToOwner; //book id to wallet address of owner
    event AddBook(address recipient, uint bookId);
    event setFinished(uint bookId, bool finished);
    function addBook(string memory name,uint16 year, string memory author,bool finished) external{
      uint bookId=bookList.length;
      bookList.push(Book(bookId,name,year,author,finished));
      bookToOwner[bookId]=msg.sender;
      emit AddBook(msg.sender,bookId);
    }

    function _getBookList(bool finished) private view returns(Book[] memory){
      Book[] memory temporary=new Book[](bookList.length);
      uint counter=0;
      for(uint i=0;i<bookList.length;i++){
        if(bookToOwner[i]==msg.sender && bookList[i].finished==finished){
          temporary[counter]=bookList[i];
          counter++;
        }
      }
       Book[] memory result=new Book[](counter);
        for(uint i=0;i<counter;i++){
          result[i]=temporary[i];
        }

        return result;
    }

    function getFinishedBooks() external view returns (Book[] memory){
      return _getBookList(true);
    }

    function getUnFinishedBooks() external view returns (Book[] memory){
      return _getBookList(false);
    }

    function SetFinished(uint bookId,bool finished) external{
      if(bookToOwner[bookId]==msg.sender){
        bookList[bookId].finished=finished;
      }
       emit setFinished(bookId, finished);
    }

   



}