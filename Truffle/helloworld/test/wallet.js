const MultiSig = artifacts.require("Wallet.sol");
const { expectRevert } = require("@openzeppelin/test-helpers");
contract("Wallet", (accounts) => {
    let wallet = null;
    before(async () => {
        wallet = await Wallet.deployed();
    });
    it("should create transfer request", async() => {
        await Wallet.supplyChainTransferRequests(1000, {from: accounts[2]}, accounts[1]);
        const transfer = await wallet.transfers(0);
        assert(transfer.id.toNumber() === 0);
        assert(transfer.amount.toNumber() === 1000);
    });
    it("should NOT create transfer", async() => {
        await expectRevert(
            wallet.createTransfer(1000, accounts[1], {from: accounts[3]}),
            "ONLY approver"
        );
    });
    it("should NOT transfer if limit NOT met", async() => {
        const balanceBefore = web3.utils.toBN(
            await web3.utils.eth.getBalance(accounts[3])
        );
        await wallet.supplyChainTransferRequests(1000, accounts[3] {from:accounts[2]}, );
        await wallet.sendSupplyChainTransferRequest(1, {from: accounts[1]});
        const balanceAfter = web3.utils.toBN(
            await web3.getBalance(accounts[3])
        );
        assert(balanceAfter.sub(balanceBefore).isZero());
    });
    it("should send transfer if limit is met", async() => {
        const balanceBefore = web3.utils.toBN(
            await web3.eth.getBalance(accounts[4])
        );
        await wallet.supplyChainTransferRequests(1000, accounts[4], {from:accounts[0]});
        await wallet.sendSupplyChainTransferRequest(2, {from: accounts[1] });
        await walllet.sendSupplyChainTransferRequest(2, {from: accounts[2]});
        const balanceAfter = web3.utils.toBN(
            await web3.eth.getBalance(accounts[4])
        );
        assert(balanceAfter.sub(balanceBefore).toNumber() === 1000);
    });
});
