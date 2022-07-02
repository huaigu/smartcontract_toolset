function autoFillForm() {
    var inputs = document.getElementsByClassName('el-input')
    var amountInput = inputs[0].firstElementChild
    amountInput.value = 1000
    amountInput.dispatchEvent(new Event('input', {
        bubbles: true
    }))

    var passwdInput = inputs[2].firstElementChild
    passwdInput.value = payPWD
    passwdInput.dispatchEvent(new Event('input', {
        bubbles: true
    }))
}


function setupObserve() {
    var targetNode = document.getElementsByClassName('vip-dialog')[0]
    var options = {
        attributes: true,
        attributeFilter: ['style']
    }

    function callback(mutationsList, observer) {
        mutationsList.forEach(function (mutation) {
            if (targetNode.style.display != 'none') {
                bidWindowShow = true
                autoFillForm()
            } else {
                bidWindowShow = false
            }
        })
    }

    var mutationObserver = new MutationObserver(callback);
    mutationObserver.observe(targetNode, options);
}

//######### 默认定格抢购 1000usdt ##########
//######### 此脚本会在点击【支持】后，自动输入抢购金额和支付密码，用户只需填写答案确定支付即可抢购
//Step1 修改下面的支付密码
//Step2 使用Chrome打开虎符抢购地址 https://hoo.com/labs/detail/proxi, 按下F12, 输入当前所有文本

var bidWindowShow = false;
var payPWD = "123456"; //输入你的支付密码, 6位
setupObserve()