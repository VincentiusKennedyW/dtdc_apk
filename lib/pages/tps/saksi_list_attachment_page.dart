import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dtdc/bloc/list_dummy/list_dummy_bloc.dart';
import 'package:dtdc/pages/tps/detail_attachment_page.dart';
import 'package:dtdc/pages/tps/form_attachment_page.dart';

final List<Map<String, dynamic>> dataDummy = [
  {
    'status': 'Kondisi',
    'timestamp': '2022-01-01 08:00:00',
    'Latitude': -1.275455,
    'Longitude': 116.833995,
    'Foto':
        'https://www.ruparupa.com/blog/wp-content/uploads/2021/04/image-27.png',
  },
  {
    'status': 'Rekapitulasi',
    'timestamp': '2022-01-02 09:15:00',
    'Latitude': -1.256788,
    'Longitude': 116.789632,
    'Foto':
        'https://www.ruparupa.com/blog/wp-content/uploads/2021/04/image-26.png',
  },
  {
    'status': 'Dokumen C1',
    'timestamp': '2022-01-03 10:30:00',
    'Latitude': -1.289000,
    'Longitude': 116.802345,
    'Foto':
        'https://www.ruparupa.com/blog/wp-content/uploads/2021/04/image-28.png',
  },
  {
    'status': 'Rekapitulasi',
    'timestamp': '2022-01-04 11:45:00',
    'Latitude': -1.272345,
    'Longitude': 116.812345,
    'Foto':
        'https://www.ruparupa.com/blog/wp-content/uploads/2021/04/image-29.png',
  },
  {
    'status': 'Kondisi',
    'timestamp': '2022-01-05 12:00:00',
    'Latitude': -1.278900,
    'Longitude': 116.825678,
    'Foto':
        'https://www.ruparupa.com/blog/wp-content/uploads/2021/04/image-30.png',
  },
  {
    'status': 'Rekapitulasi',
    'timestamp': '2022-01-06 13:15:00',
    'Latitude': -1.267890,
    'Longitude': 116.834567,
    'Foto':
        'https://www.ruparupa.com/blog/wp-content/uploads/2021/04/image-31.png',
  },
  {
    'status': 'Dokumen C1',
    'timestamp': '2022-01-07 14:30:00',
    'Latitude': -1.260000,
    'Longitude': 116.841234,
    'Foto':
        'https://www.ruparupa.com/blog/wp-content/uploads/2021/04/image-32.png',
  },
  {
    'status': 'Dokumen C1',
    'timestamp': '2022-01-08 15:45:00',
    'Latitude': -1.275678,
    'Longitude': 116.850000,
    'Foto':
        'https://www.ruparupa.com/blog/wp-content/uploads/2021/04/image-33.png',
  },
  {
    'status': 'Dokumen C1',
    'timestamp': '2022-01-09 16:00:00',
    'Latitude': -1.270123,
    'Longitude': 116.860987,
    'Foto':
        'https://www.ruparupa.com/blog/wp-content/uploads/2021/04/image-34.png',
  },
  {
    'status': 'Dokumen C1',
    'timestamp': '2022-01-10 17:15:00',
    'Latitude': -1.280234,
    'Longitude': 116.870123,
    'Foto':
        'https://www.ruparupa.com/blog/wp-content/uploads/2021/04/image-35.png',
  }
];

class SaksiListAttachmentPage extends StatelessWidget {
  const SaksiListAttachmentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ListDummyBloc()..add(LoadDataEvent(data: dataDummy)),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Daftar Foto Saksi'),
          centerTitle: true,
        ),
        body: BlocBuilder<ListDummyBloc, ListDummyState>(
          builder: (context, state) {
            if (state is ListDummyInitial) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is ListDummyLoaded) {
              return ListView.separated(
                itemCount: state.data.length,
                separatorBuilder: (context, index) => const Divider(),
                itemBuilder: (BuildContext context, int index) {
                  final item = state.data[index];
                  return ListTile(
                    title: Text(item['status']),
                    subtitle: Text(item['timestamp']),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              DetailAttachmentPage(data: item),
                        ),
                      );
                    },
                  );
                },
              );
            } else {
              return const Center(child: Text('Data tidak tersedia.'));
            }
          },
        ),
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const FormAttachmentPage(),
              ),
            );
          },
        ),
      ),
    );
  }
}
