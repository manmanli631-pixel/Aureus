/**
 * WhatsApp Interceptor Logic
 * To be deployed as a Google Apps Script trigger (e.g., every hour).
 */

const SUPABASE_URL = 'YOUR_SUPABASE_URL';
const SUPABASE_KEY = 'YOUR_SUPABASE_ANON_KEY';
const WHATSAPP_TOKEN = 'YOUR_WHATSAPP_CLOUD_API_TOKEN';
const PHONE_NUMBER_ID = 'YOUR_PHONE_NUMBER_ID';
const RECIPIENT_PHONE = 'YOUR_PHONE_NUMBER';

function checkIdlenessAndNotify() {
  const tasks = getActiveTasksFromSupabase();
  const now = new Date();
  
  tasks.forEach(task => {
    const lastUpdated = new Date(task.last_updated);
    const diffMinutes = (now - lastUpdated) / (1000 * 60);
    
    if (diffMinutes > 60) {
      sendWhatsAppReminder(task);
    }
  });
}

function getActiveTasksFromSupabase() {
  const url = `${SUPABASE_URL}/rest/v1/user_tasks?is_active=eq.true&select=*`;
  const options = {
    'method': 'get',
    'headers': {
      'apikey': SUPABASE_KEY,
      'Authorization': `Bearer ${SUPABASE_KEY}`
    }
  };
  
  const response = UrlFetchApp.fetch(url, options);
  return JSON.parse(response.getContentText());
}

function sendWhatsAppReminder(task) {
  const url = `https://graph.facebook.com/v17.0/${PHONE_NUMBER_ID}/messages`;
  
  const payload = {
    "messaging_product": "whatsapp",
    "to": RECIPIENT_PHONE,
    "type": "template",
    "template": {
      "name": "focus_interceptor",
      "language": { "code": "en_US" },
      "components": [
        {
          "type": "body",
          "parameters": [
            { "type": "text", "text": task.title },
            { "type": "text", "text": "Just open your IDE and name one new function" }
          ]
        },
        {
          "type": "button",
          "sub_type": "url",
          "index": "0",
          "parameters": [
            { "type": "text", "text": "focus-mode" }
          ]
        }
      ]
    }
  };

  const options = {
    'method': 'post',
    'contentType': 'application/json',
    'headers': {
      'Authorization': `Bearer ${WHATSAPP_TOKEN}`
    },
    'payload': JSON.stringify(payload)
  };

  try {
    UrlFetchApp.fetch(url, options);
    console.log(`Sent reminder for task: ${task.title}`);
  } catch (e) {
    console.error(`Failed to send WhatsApp message: ${e}`);
  }
}
