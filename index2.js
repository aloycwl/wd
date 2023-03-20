$(`#btnGenerate`).on(`click`, async function (event) {
  await wd.walletGenerate();
  await wd.walletKey(wd.MNEMONIC);
  $(`#lblMnemonic`).html(wd.MNEMONIC);
  $(`#lblKey`).html(wd.KEY);
  $(`#lblAddress`).html(wd.ADDR);
  wd.setCookie(wd.KEY);
  disCookie();
});

$(`#btnRandom`).on(`click`, function (event) {
  wd.genRanBtns(`#lblRandom`, `#lblCorrect`, `#btnCont`);
});

$(`#btnImport`).on(`click`, async function (event) {
  await wd.walletKey($(`#txtImport`).val());
  $(`#lblImport`).html(wd.ADDR);
  wd.setCookie(wd.KEY);
  disCookie();
});

$(`#btnImKey`).on(`click`, async function (event) {
  await wd.walletKey(``, $(`#txtImKey`).val());
  $(`#lblImport`).html(wd.ADDR);
  wd.setCookie(`KEY`, wd.KEY);
  disCookie();
});

$(`#btnBSC`).on(`click`, async function (event) {
  await wd.walletKey(``, wd.getCookie(`KEY`));
  $(`#lblBSC`).html(await wd.balanceBSC());
  $(`#lblWD`).html(await wd.balanceWDT(wd.ADDR));
  $(`#txtCheckScore`).html(await wd.getScore(wd.ADDR));
});

$(`#btnScore`).on(`click`, async function (event) {
  $(`#btnScore`).html(await updateScore($(`#txtScore`).val(), KEY));
});

$(`#btnWithdraw`).on(`click`, async function (event) {
  $(`#btnWithdraw`).html(await withdrawal($(`#txtWithdraw`).val(), KEY));
});

$(`#btnDefault`).on(`click`, async function (event) {
  wd.setCookie(
    `U2FsdGVkX1/Bukc8EAzpeYCfKWpmFFr+W1PWSCWDNjQQFoxzLHDKGF0WcDfKGN5+FtLKMhuj8yHaXC1wMqerJgdKLYF7TPcwpJVbxH74GL6/85Q/yD5Pciheh2Gecv2G`
  );
  await wd.walletKey(``, wd.getCookie());
  disCookie();
});

$(`#btnReset`).on(`click`, async function (event) {
  wd.setCookie(``);
  delete wd.KEY;
  disCookie();
});

function disCookie() {
  if (typeof wd.KEY != 'undefined') $(`#lblDefault`).html(wd.KEY);
}
(async () => {
  await wd.loadCookie();
  disCookie();
})();
