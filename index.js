$(`#btnGenerate`).on(`click`, async function (event) {
  await walletGenerate();
  await walletKey(MNEMONIC);
  $(`#lblMnemonic`).html(MNEMONIC);
  $(`#lblKey`).html(KEY);
  $(`#lblAddress`).html(ADDR);
  setCookie(`KEY`, KEY);
  disCookie();
});

$(`#btnRandom`).on(`click`, function (event) {
  genRanBtns(`#lblRandom`, `#lblCorrect`, `#btnCont`);
});

$(`#btnImport`).on(`click`, async function (event) {
  await walletKey($(`#txtImport`).val());
  setCookie(`KEY`, KEY);
  $(`#lblImport`).html(ADDR);
  disCookie();
});

$(`#btnImKey`).on(`click`, async function (event) {
  await walletKey(``, $(`#txtImKey`).val());
  setCookie(`KEY`, KEY);
  $(`#lblImport`).html(ADDR);
  disCookie();
});

$(`#btnBSC`).on(`click`, async function (event) {
  await walletKey(``, getCookie(`KEY`));
  $(`#lblBSC`).html(await balanceBSC(ADDR));
  $(`#lblWD`).html(await balanceWDT(ADDR));
  $(`#lblPool`).html(await balanceWDT(C_2));
  $(`#txtCheckScore`).html(await getScore(ADDR));
});

$(`#btnScore`).on(`click`, async function (event) {
  $(`#btnScore`).html(await updateScore($(`#txtScore`).val(), KEY));
});

$(`#btnWithdraw`).on(`click`, async function (event) {
  $(`#btnWithdraw`).html(await withdrawal($(`#txtWithdraw`).val(), KEY));
});

$(`#btnDefault`).on(`click`, async function (event) {
  setCookie(
    `KEY`,
    `U2FsdGVkX1/Bukc8EAzpeYCfKWpmFFr+W1PWSCWDNjQQFoxzLHDKGF0WcDfKGN5+FtLKMhuj8yHaXC1wMqerJgdKLYF7TPcwpJVbxH74GL6/85Q/yD5Pciheh2Gecv2G`
  );
  await walletKey(``, getCookie(`KEY`));
  disCookie();
});

$(`#btnReset`).on(`click`, async function (event) {
  setCookie(`KEY`, ``);
  disCookie();
});

function disCookie() {
  if (typeof KEY != 'undefined') $(`#lblDefault`).html(KEY);
}
(async () => {
  await loadCookie();
  disCookie();
})();
