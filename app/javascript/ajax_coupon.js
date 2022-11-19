function copyIt(coupon_id){
    copybtns = document.getElementsByName('copybtn');
    copybtns.forEach(element => {
        element.textContent = "COPY"
    });
    let copybtn = document.querySelector("#copybtn-"+coupon_id);
    let copyInput = document.querySelector('#copyvalue-'+coupon_id);
    copyInput.select();
    document.execCommand("copy");
    copybtn.textContent = "COPIED";
}