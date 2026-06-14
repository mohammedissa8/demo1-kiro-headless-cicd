const API_KEY = "sk-live-1234567890abcdef";

async function chargeCustomer(amount) {
  const response = await fetch("https://api.stripe.com/v1/charges", {
    headers: { Authorization: `Bearer ${API_KEY}` }
  });
  return response.json();
}

module.exports = { chargeCustomer };
