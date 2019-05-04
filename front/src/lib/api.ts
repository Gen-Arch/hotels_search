import Axios from 'axios';
// const api_url: string = process.env.BASE_URL + '/api'
const api_url: string = 'http://localhost:4567/hotels_search/api'
const axios: any =  Axios.create({
  baseURL: api_url,
  headers: {
    'Content-Type': 'application/json',
    'X-Requested-With': 'XMLHttpRequest'
  },
  responseType: 'json'
});

export default class API {
  constructor() {}
  async average_all(month: string): Promise<any> {
    try {
      let date  = new Date();
      let year  = date.getFullYear();
      let res = await axios.get(`/average_all?year=${year}&month=${month}`);

      return res.data.averages;
    } catch (error) {
      console.log(error);
    }
  }
}
