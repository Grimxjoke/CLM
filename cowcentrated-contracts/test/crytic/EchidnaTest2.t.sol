pragma solidity 0.8.23;

// import {Test, console} from "forge-std/Test.sol";
import {Setup} from "./Setup2.t.sol";
import {CustomActor} from "./CustomActor.sol";
import "Hevm.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./VelodromeLiquidityProvider.sol"

// Test ETH/USDT Uniswap Strategy. Large decimal token0 and small decimal token1;
contract  EchidnaTest2 is Setup2 {

    CustomActor normalUser;
    CustomActor attacker;

    bool isSetupCompleted;
    VelodromeLiquidityProvider lpProvider;
    function setUp(){
        if (!isSetupCompleted)
        {
            super.setUp();
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
            token0Token.mint(address(attacker),1000000*10**token0Token.decimals());
            hevm.prank(token1Owner);
            token1Token.mint(address(attacker),1000000*10**token1Token.decimals());
            hevm.prank(nativeOwner);
            nativeToken.mint(address(attacker),1000000*10**nativeToken.decimals());
            isSetupCompleted=true;

            //veldrome lp
            lpProvider = new VelodromeLiquidityProvider(unirouter,token0,token1,native);
        }

        
    }
    function echidna_test_calm_period(uint deposit0,uint deposit1) external pure returns (bool) {
        if(!isSetupCompleted)setUp();

        //get current price
        uint currentPrice = strategy.price();
        console.log("Price before... ",currentPrice);

        attacker.proxy(address(lpProvider),abi.encodeWithSelector(lpProvider.deposit.selector,deposit0,deposit1,deposit0,deposit1,address(attacker),block.timestamp));

        uint newPrice = strategy.price();
        console.log("Price after... ",newPrice);




    }

}
    