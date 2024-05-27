//SPDX-License-Identifier: MIT
pragma solidity 0.8.23;

// import {Test, console} from "forge-std/Test.sol";
import {Setup2} from "./Setup2.sol";
import {CustomActor} from "./CustomActor.sol";
import "./Hevm.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./VeldromeLiquidityProvider.sol";
import "forge-std/console.sol";

// Test ETH/USDT Uniswap Strategy. Large decimal token0 and small decimal token1;
contract  EchidnaTest2 is Setup2 {

    CustomActor normalUser;
    CustomActor attacker;

    bool isSetupCompleted;
    VelodromeLiquidityProvider lpProvider;
    function initialize() public{
        if (!isSetupCompleted)
        {
            setUp();
            normalUser = new  CustomActor();
            attacker = new CustomActor();

            //assigning some extra tokens to users
            ERC20 token0Token = ERC20(token0);
            ERC20 token1Token = ERC20(token1);
            ERC20 nativeToken = ERC20(native);
            
            address token0Owner  = Ownable(token0).owner();
            address token1Owner  = Ownable(token1).owner();
            address nativeOwner  = Ownable(native).owner();

            //giving some extra tokens to our attacker
            hevm.prank(token0Owner);
            token0Token.transfer(address(attacker),1000000*10**token0Token.decimals());
            hevm.prank(token1Owner);
            token1Token.transfer(address(attacker),1000000*10**token1Token.decimals());

            //the following transfer is not needed as the native token is the same as token1
            // hevm.prank(nativeOwner);
            // nativeToken.mint(address(attacker),1000000*10**nativeToken.decimals());

            

            //veldrome lp
            lpProvider = new VelodromeLiquidityProvider(unirouter,token0,token1,false);


            isSetupCompleted=true;
        }

        
    }
    function testCalmPeriods(uint deposit0,uint deposit1) external {
        console.log("[+] Testing calm periods. ");
        if(!isSetupCompleted)setUp();

        //get current price
        uint currentPrice = strategy.price();
        console.log("Price before... ",currentPrice);

        attacker.proxy(address(lpProvider),abi.encodeWithSelector(lpProvider.deposit.selector,deposit0,deposit1,deposit0,deposit1,address(attacker),block.timestamp));

        uint newPrice = strategy.price();
        console.log("Price after... ",newPrice);
        

        



    }

}
    