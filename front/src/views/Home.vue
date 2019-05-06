<template>
  <div class="home">
    <v-layout wrap align-center>
      <v-flex xs12 sm3 d-flex>
        <v-select
          :items="months"
          v-model="month"
          @change="get_average(month)"
          label="月を指定してください"
          ></v-select>
      </v-flex>
      <v-flex xs12 d-flex>
        <v-data-table
          :headers="headers"
          :items="averages"
          class="elevation-1"
          >
          <template v-slot:items="props">
            <td>{{ props.item.name }}</td>
            <td>{{ props.item.plan }}</td>
            <td>{{ '￥' + props.item.average }}</td>
          </template>
        </v-data-table>
      </v-flex>
    </v-layout>
  </div>
</template>

<script lang="ts">
import { Component, Vue } from "vue-property-decorator";
import API from "../lib/api"

@Component({})
export default class Home extends Vue {
  averages: object[] = [];
  month: string = '';
  months: string[] = ['1','2','3','4','5','6','7','8','9','10','11','12']
  headers: object[] = [
    {
      text: 'hotel name',
      align: 'left',
      value: 'name'
    },
    { text: 'plan', value: 'plan' },
    { text: '平均金額', value: 'average' },
  ];

  mounted(): void {
    let date  = new Date();
    let month = date.getMonth() + 1;
    this.get_average(String(month));
  }

  get_average(month: string): void {
    console.log(month)
    let api = new API();
    api.average_all(month)
    .then(res => this.averages = res);
  }
}
</script>
